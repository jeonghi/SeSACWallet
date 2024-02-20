//
//  AddViewController.swift
//  SeSACWallet
//
//  Created by 쩡화니 on 2/16/24.
//

import RealmSwift
import SnapKit
import UIKit
import PhotosUI

protocol PassDataDelegate {
  func memoReceived(text: String)
}

class AddViewController: BaseViewController {
  
  let moneyButton = UIButton()
  let categoryButton = UIButton()
  let memoButton = UIButton()
  let photoImageView = UIImageView()
  let addButton = UIButton()
  
  let repository = AccountBookTableRepositoryImpl()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // 사진, 시간, 위치
    PHAsset.fetchAssets(with: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(categoryReceivedNotificationObserved), name: NSNotification.Name("CategoryReceived"), object: nil)
  }
  
  @objc func categoryReceivedNotificationObserved(notification: NSNotification) {
    if let value = notification.userInfo?["category"] as? String {
      categoryButton.setTitle(value, for: .normal)
    }
  }
  
  override func configureHierarchy() {
    view.addSubview(moneyButton)
    view.addSubview(categoryButton)
    view.addSubview(memoButton)
    view.addSubview(photoImageView)
    view.addSubview(addButton)
  }
  
  override func configureConstraints() {
    moneyButton.snp.makeConstraints { make in
      make.width.equalTo(300)
      make.height.equalTo(50)
      make.centerX.equalTo(view)
      make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
    }
    
    categoryButton.snp.makeConstraints { make in
      make.top.equalTo(moneyButton.snp.bottom).offset(24)
      make.centerX.equalTo(view)
      make.width.equalTo(300)
      make.height.equalTo(50)
    }
    
    memoButton.snp.makeConstraints { make in
      make.top.equalTo(categoryButton.snp.bottom).offset(24)
      make.centerX.equalTo(view)
      make.width.equalTo(300)
      make.height.equalTo(50)
    }
    
    photoImageView.snp.makeConstraints { make in
      make.top.equalTo(memoButton.snp.bottom).offset(44)
      make.size.equalTo(300)
      make.centerX.equalTo(view)
    }
    
    addButton.snp.makeConstraints { make in
      make.top.equalTo(photoImageView.snp.bottom).offset(24)
      make.width.equalTo(300)
      make.height.equalTo(50)
      make.centerX.equalTo(view)
    }
  }
  
  override func configureView() {
    super.configureView()
    
    photoImageView.backgroundColor = .orange
    
    addButton.setTitle("이미지", for: .normal)
    addButton.setTitleColor(.white, for: .normal)
    addButton.backgroundColor = .orange
    addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonTapped))
    
    moneyButton.setTitle("금액", for: .normal)
    moneyButton.setTitleColor(.white, for: .normal)
    moneyButton.backgroundColor = .orange
    moneyButton.addTarget(self, action: #selector(moneyButtonTapped), for: .touchUpInside)
    
    categoryButton.setTitle("카테고리", for: .normal)
    categoryButton.setTitleColor(.white, for: .normal)
    categoryButton.backgroundColor = .systemOrange
    categoryButton.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
    
    memoButton.setTitle("메모", for: .normal)
    memoButton.setTitleColor(.white, for: .normal)
    memoButton.backgroundColor = .systemOrange
    memoButton.addTarget(self, action: #selector(memoButtonTapped), for: .touchUpInside)
  }
  
  @objc func addButtonTapped() {
//    let vc = UIImagePickerController()
//    vc.allowsEditing = true
//    vc.delegate = self
//    present(vc, animated: true)
    var configuration = PHPickerConfiguration()
    configuration.selectionLimit = 3 // 최대 선택가능한 사진 갯수
    configuration.filter = .any(of: [.videos, .images])
    let picker = PHPickerViewController(configuration: configuration)
    picker.delegate = self
    present(picker, animated: true)
  }
  
  @objc func saveButtonTapped() {
    let money = Int.random(in: 100...5000) * 10
    let data = AccountBookTable(money: money, category: "study", memo: nil, registerationDate: Date(), usageDate: Date(), isDeposit: false)
    
    repository.createItem(data)
    
    if let image = photoImageView.image {
      saveImageToDocument(image: image, fileName: "\(data.id)")
    }
  }
  
  @objc func moneyButtonTapped() {
    let vc = MoneyViewController()
    vc.money = "0"
    vc.getMoney = { newValue in
      self.moneyButton.setTitle(newValue, for: .normal)
    }
    navigationController?.pushViewController(vc, animated: true)
  }
  
  @objc func categoryButtonTapped() {
    let vc = CategoryViewController()
    navigationController?.pushViewController(vc, animated: true)
  }
  
  @objc func memoButtonTapped() {
    
    let vc = MemoViewController()
    vc.delegate = self
    navigationController?.pushViewController(vc, animated: true)
  }
}

extension AddViewController: PassDataDelegate {
  func memoReceived(text: String) {
    memoButton.setTitle(text, for: .normal)
  }
}

extension AddViewController: PHPickerViewControllerDelegate {
  func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    
    picker.dismiss(animated: true)
    
    if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
      itemProvider.loadObject(ofClass: UIImage.self) { image, error in
        DispatchQueue.main.async {
          
          // UIImage must conform to _ObjectiveCBridgeable in PHPickerViewControllerDelegate callback 컴파일 에러
          self.photoImageView.image = image as? UIImage
        }
      }
    }
  }
  
  
}

extension AddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
      photoImageView.image = pickedImage
    }
    dismiss(animated: true)
  }
}

@available(iOS 17.0, *)
#Preview {
  AddViewController()
}

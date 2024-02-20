//
//  CategoryViewController.swift
//  SeSACWallet
//
//  Created by 쩡화니 on 2/16/24.
//

import UIKit

class CategoryViewController: BaseViewController {
  
  let categoryTextField = UITextField()
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    NotificationCenter.default.post(name: NSNotification.Name("CategoryReceived"), object: nil, userInfo: ["category": categoryTextField.text!])
  }
  
  override func configureHierarchy() {
    view.addSubview(categoryTextField)
  }
  
  override func configureConstraints() {
    categoryTextField.snp.makeConstraints { make in
      make.width.equalTo(300)
      make.height.equalTo(50)
      make.centerX.equalTo(view)
      make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
    }
  }
  
  override func configureView() {
    super.configureView()
    categoryTextField.placeholder = "category"
    categoryTextField.backgroundColor = .lightGray
  }
}

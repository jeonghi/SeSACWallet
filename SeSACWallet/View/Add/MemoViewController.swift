//
//  MemoViewController.swift
//  SeSACWallet
//
//  Created by 쩡화니 on 2/16/24.
//

import UIKit

class MemoViewController: BaseViewController {
  
  let memoTextView = UITextView()
  var delegate: PassDataDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    NotificationCenter.default.addObserver(self, selector: #selector(memoNotificationObserved), name: NSNotification.Name("MemoPost"), object: nil)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    delegate?.memoReceived(text: memoTextView.text!)
  }
  
  @objc func memoNotificationObserved(_ notification: NSNotification) {
    print(notification)
  }
  
  override func configureHierarchy() {
    view.addSubview(memoTextView)
  }
  
  override func configureConstraints() {
    memoTextView.snp.makeConstraints { make in
      make.width.equalTo(300)
      make.height.equalTo(50)
      make.centerX.equalTo(view)
      make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
    }
  }
  
  override func configureView() {
    super.configureView()
    memoTextView.backgroundColor = .lightGray
  }
}

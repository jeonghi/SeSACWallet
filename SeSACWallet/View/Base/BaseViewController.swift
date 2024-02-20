//
//  BaseViewController.swift
//  SeSACWallet
//
//  Created by 쩡화니 on 2/16/24.
//

import Toast
import UIKit

class BaseViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureHierarchy()
    configureView()
    configureConstraints()
    
  }
  
  func configureHierarchy() {}
  
  func configureView() {
    view.backgroundColor = .white
  }
  
  func configureConstraints() {}
  
  func showAlert(
    title: String,
    message: String,
    ok: String,
    handler: @escaping (() -> Void)
  ) {
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    let ok = UIAlertAction(title: ok, style: .default) { _ in
      handler()
    }
    let cancel = UIAlertAction(title: "cancel", style: .cancel)
    alert.addAction(ok)
    alert.addAction(cancel)
    present(alert, animated: true)
    
  }
  
  func showToast() {
    view.makeToast("알림")
  }
  
}

//
//  MoneyViewController.swift
//  SeSACWallet
//
//  Created by 쩡화니 on 2/16/24.
//

import UIKit

class MoneyViewController: BaseViewController {
  
  let moneyTextField = UITextField()
  var money: String?
  var getMoney: ((String) -> Void)?
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    moneyTextField.becomeFirstResponder()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    getMoney?(moneyTextField.text!)
  }
  
  override func configureHierarchy() {
    view.addSubview(moneyTextField)
  }
  
  override func configureConstraints() {
    moneyTextField.snp.makeConstraints { make in
      make.width.equalTo(300)
      make.height.equalTo(50)
      make.centerX.equalTo(view)
      make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
    }
  }
  
  override func configureView() {
    super.configureView()
    moneyTextField.placeholder = "금액 입력:"
    moneyTextField.keyboardType = .numberPad
    moneyTextField.backgroundColor = .white
    moneyTextField.text = money
  }
  
}

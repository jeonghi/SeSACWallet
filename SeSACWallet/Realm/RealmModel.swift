//
//  RealmModel.swift
//  SeSACWallet
//
//  Created by 쩡화니 on 2/16/24.
//

import Foundation
import RealmSwift

class Folder: Object {
  @Persisted(primaryKey: true) var id: ObjectId
  @Persisted var folderName: String
  @Persisted var createdAt: Date
  @Persisted var accountBookList: List<AccountBookTable>
  
  convenience init(folderName: String, accountBookList: List<AccountBookTable> = .init(), createdAt: Date = Date()) {
    self.init()
    self.folderName = folderName
    self.accountBookList = accountBookList
    self.createdAt = createdAt
  }
}

class AccountBookTable: Object {
  
  @Persisted(primaryKey: true) var id: ObjectId
  @Persisted var money: Int
  @Persisted var category: String
  @Persisted var memo: String?
  @Persisted var registerationDate: Date
  @Persisted var usageDate: Date
  @Persisted var isDeposit: Bool
  @Persisted var isFavorite: Bool
  
  
  convenience init(money: Int, category: String, memo: String? = nil, registerationDate: Date, usageDate: Date, isDeposit: Bool) {
    self.init()
    self.money = money
    self.category = category
    self.memo = memo
    self.registerationDate = registerationDate
    self.usageDate = usageDate
    self.isDeposit = isDeposit
    self.isFavorite = false
  }
}

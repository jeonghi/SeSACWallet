//
//  FolderRepository.swift
//  SeSACWallet
//
//  Created by 쩡화니 on 2/20/24.
//

import RealmSwift
import Foundation

protocol FolderRepository {
  func createItem(_ item: Folder)
}

final class FolderRepositoryImpl: FolderRepository {
  
  let realm = try! Realm()
  
  func createItem(_ item: Folder) {
    try? realm.write {
      realm.add(item)
    }
  }
  
  func getItems() -> Results<Folder> {
    return realm.objects(Folder.self)
  }
}

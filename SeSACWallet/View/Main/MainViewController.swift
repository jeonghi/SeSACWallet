//
//  MainViewController.swift
//  SeSACWallet
//
//  Created by 쩡화니 on 2/16/24.
//

import FSCalendar
import RealmSwift
import SnapKit
import UIKit

class MainViewController: BaseViewController {
  
  let tableView = UITableView()
  let calendar = FSCalendar()
  
  var list: Results<AccountBookTable>!
  let accountBookTableRepository = AccountBookTableRepositoryImpl()
  let folderRepository = FolderRepositoryImpl()
  
  let realm = try! Realm()
  let dateFormat = DateFormatter()
  
  
  // 얘는 한번만 실행돼
  override func viewDidLoad() {
    super.viewDidLoad()
    
    dateFormat.dateFormat = "yyyy년 MM월 dd일 hh시"
    
    // Dummy
//    let folderList = ["개인", "업무", "동아리"]
//    
//    folderList.forEach {
//      folderRepository.createItem(.init(folderName: $0))
//    }
    
//    let date = folderRepository.getItems().first!
//    let account = AccountBookTable(money: 3000, category: "여기", registerationDate: Date(), usageDate: Date(), isDeposit: true)
//    do {
//      try realm.write {
//        data.accountBookList.append(account)
//      }
//    } catch {
//      print("\(error)")
//    }
    
    print(realm.configuration.fileURL)
    list = accountBookTableRepository.fetchItem("study")
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    tableView.reloadData()
    
  }
  
  override func configureHierarchy() {
    view.addSubview(tableView)
    view.addSubview(calendar)
  }
  
  override func configureConstraints() {
    calendar.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
      make.height.equalTo(500)
    }
    
    tableView.snp.makeConstraints { make in
      make.top.equalTo(calendar.snp.bottom)
      make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
    }
  }
  
  override func configureView() {
    super.configureView()
    
    // MARK: FSCalendar
    calendar.delegate = self
    calendar.dataSource = self
    calendar.locale = Locale(identifier: "ko-KR")
    
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "mainCell")
    
    navigationItem.title = "용돈기입장"
    
    let rightitem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(tappedRightBarButton))
    navigationItem.rightBarButtonItem = rightitem
    
    let leftitem = UIBarButtonItem(title: "오늘", style: .plain, target: self, action: #selector(tappedTodayButton))
    let allleftitem = UIBarButtonItem(title: "전체", style: .plain, target: self, action: #selector(tappedAllButton))
    navigationItem.leftBarButtonItems = [leftitem, allleftitem]
  }
  
  @objc func tappedRightBarButton() {
    let vc = AddViewController()
    navigationController?.pushViewController(vc, animated: true)
  }
  
  @objc func tappedTodayButton() {
    let start = Calendar.current.startOfDay(for: Date())
    let end: Date = Calendar.current.date(byAdding: .day, value: 1, to: start) ?? Date()
    
    let predicate = NSPredicate(format: "registerationDate >= %@ && registerationDate < %@", start as NSDate, end as NSDate)
    
    list = realm.objects(AccountBookTable.self).filter(predicate)
    tableView.reloadData()
  }
  
  @objc func tappedAllButton() {
    list = realm.objects(AccountBookTable.self)
  }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return list.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell")!
    let row = list[indexPath.row]
    
    let result = dateFormat.string(from: row.registerationDate)
    
    cell.textLabel?.text = "\(result)|\(row.money)원 \(row.category)"
    
    if let image = loadImageFromDocument(fileName: "\(row.id)") {
      cell.imageView?.image = image
    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let row = list[indexPath.row]
    
    removeImageFromDocument(filename: "\(row.id)")
    
    try! realm.write {
      realm.delete(list[indexPath.row])
    }
    
    tableView.reloadData()
  }
}

extension MainViewController: FSCalendarDelegate, FSCalendarDataSource {
  
  func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
    
    let start = Calendar.current.startOfDay(for: date)
    let end: Date = Calendar.current.date(byAdding: .day, value: 1, to: start) ?? Date()
    let predicate = NSPredicate(format: "registerationDate >= %@ && registerationDate < %@", start as NSDate, end as NSDate)
    
    list = realm.objects(AccountBookTable.self).filter(predicate)
    tableView.reloadData()
    let events = min(list.count, 3)
    return events
  }
  
  func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
    
    let start = Calendar.current.startOfDay(for: date)
    
    let end: Date = Calendar.current.date(byAdding: .day, value: 1, to: start) ?? Date()
    
    let predicate = NSPredicate(format: "registerationDate >= %@ && registerationDate < %@", start as NSDate, end as NSDate)
    
    list = realm.objects(AccountBookTable.self).filter(predicate)
    
    tableView.reloadData()
  }
}

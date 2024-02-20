//
//  FileManager+Extension.swift
//  SeSACWallet
//
//  Created by 쩡화니 on 2/16/24.
//

import UIKit

extension UIViewController {
    func saveImageToDocument(image: UIImage, fileName: String) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let fileURL = documentDirectory.appendingPathComponent("\(fileName).jpg")
        
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
        
        do {
            try data.write(to: fileURL)
        } catch {
            print("file save error")
        }
    }
  
    func loadImageFromDocument(fileName: String) -> UIImage? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileURL = documentDirectory.appendingPathComponent("\(fileName).jpg")
        if FileManager.default.fileExists(atPath: fileURL.path()) {
            return UIImage(contentsOfFile: fileURL.path())
        } else {
            return UIImage(systemName: "person")
        }
    }
  
  func removeImageFromDocument(filename: String) {
    guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
      return
    }
    
    let fileURL = documentDirectory.appendingPathComponent("\(filename).jpg")
    
    if FileManager.default.fileExists(atPath: fileURL.path()) {
      do {
        try FileManager.default.removeItem(at: fileURL)
      } catch {
        print("file remove error", error)
      }
    } else {
      print("file no exist, remove")
    }
  }
}

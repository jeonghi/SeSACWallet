//
//  SceneDelegate.swift
//  SeSACWallet
//
//  Created by 쩡화니 on 2/16/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let scene = (scene as? UIWindowScene) else { return }
    
    window = UIWindow(windowScene: scene)
    let vc = UINavigationController(rootViewController: MainViewController())
    window?.rootViewController = vc
    window?.makeKeyAndVisible()
  }
  
}


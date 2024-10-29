//
//  SceneDelegate.swift
//  InvestMate
//
//  Created by 조호근 on 10/1/24.
//

import UIKit
import Presentation
import Domain
import Data

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        // 의존성 주입
        let calculator = StockCalculatorImpl()
        
        let tabBarController = MainTabBarController(calculator: calculator)
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        self.window = window
    }
}

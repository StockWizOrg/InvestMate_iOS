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
        
        setupGlobalNavigationBarAppearance()
        
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        window.overrideUserInterfaceStyle = .light
        window.tintColor = UIColor.customBlack(.chineseBlack)
        self.window = window
        
        let splashViewController = SplashViewController()
        window.rootViewController = splashViewController
        window.makeKeyAndVisible()
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.setupTabBarInterface()
        }
    }
    
}

extension SceneDelegate {
    
    func setupGlobalNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemGray6
        appearance.shadowColor = nil
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 20, weight: .bold)
        ]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    private func setupTabBarInterface() {
        let calculator = StockCalculatorImpl()
        let profitCalculator = ProfitCalculatorImpl()
        let versionChecker = AppVersionCheckImpl()
        
        do {
            let repository = try StockRepositoryImpl()
            let stockManager = StockManagementImpl(
                repository: repository,
                calculator: calculator
            )
            
            let tabBarController = MainTabBarController(
                calculator: calculator,
                profitCalculator: profitCalculator,
                stockManager: stockManager,
                versionChecker: versionChecker
            )
            
            window?.rootViewController = tabBarController
            
        } catch {
            print("Repository 초기화 실패: \(error)")
            let errorVC = UIViewController()
            errorVC.view.backgroundColor = .systemBackground
            window?.rootViewController = errorVC
        }
    }
    
}

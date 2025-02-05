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
        setupGlobalTabBarAppearance()
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        window.overrideUserInterfaceStyle = .light
        
        // 의존성 주입
        let calculator = StockCalculatorImpl()
        let profitCalculator = ProfitCalculatorImpl()
        
        
        // repository 생성 시 에러 처리
        do {
            let repository = try StockRepositoryImpl()
            let stockManager = StockManagementImpl(
                repository: repository,
                calculator: calculator
            )
            
            let tabBarController = MainTabBarController(
                calculator: calculator,
                profitCalculator: profitCalculator,
                stockManager: stockManager
            )
            
            window.rootViewController = tabBarController
            window.makeKeyAndVisible()
            self.window = window
            
        } catch {
            // 에러 처리
            print("Repository 초기화 실패: \(error)")
            // 적절한 에러 처리 UI 표시
            let errorVC = UIViewController()
            errorVC.view.backgroundColor = .systemBackground
            window.rootViewController = errorVC
            window.makeKeyAndVisible()
            self.window = window
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
    
    func setupGlobalTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .systemGray6
        appearance.shadowColor = UIColor.gray.withAlphaComponent(0.2)
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
}

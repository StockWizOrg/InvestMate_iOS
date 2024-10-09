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
        
        // UIWindowScene을 가져옵니다.
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // 의존성 주입
        let stockRepository = StockRepositoryImpl()
        let stockUseCase = StockUseCaseImpl(repository: stockRepository)
        let viewModel = StockViewModel(stockUseCase: stockUseCase)
        
        // UIWindow 설정
        window = UIWindow(windowScene: windowScene)
        let viewController = ViewController()
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
}

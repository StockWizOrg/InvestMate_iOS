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
        
        // UIWindow 설정
        window = UIWindow(windowScene: windowScene)
        let viewController = AdditionalPurchaseViewController(reactor: AdditionalPurchaseReactor(calculator: StockCalculatorImpl()), calculator: StockCalculatorImpl())
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }
}

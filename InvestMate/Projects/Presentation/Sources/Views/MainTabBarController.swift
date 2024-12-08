//
//  MainTabBarController.swift
//  Presentation
//
//  Created by 조호근 on 10/28/24.
//

import UIKit

import Domain

public final class MainTabBarController: UITabBarController {
    
    private let calculator: StockCalculatorUseCase
    private let profitCalculator: ProfitCalculatorUseCase
    
    public init(
        calculator: StockCalculatorUseCase,
        profitCalculator: ProfitCalculatorUseCase
    ) {
        self.calculator = calculator
        self.profitCalculator = profitCalculator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewControllers()
        setupTabBarAppearance()
    }
    
    private func setupViewControllers() {
        // 추가 매수 탭
        let additionalPurchaseVC = AdditionalPurchaseViewController(
            reactor: AdditionalPurchaseReactor(calculator: calculator),
            calculator: calculator
        )
        let additionalPurchaseNav = UINavigationController(rootViewController: additionalPurchaseVC)
        additionalPurchaseVC.tabBarItem = UITabBarItem(
            title: "추가 매수",
            image: UIImage(systemName: "plus.circle"),
            selectedImage: UIImage(systemName: "plus.circle.fill")
        )
        
        // 수익 계산 탭
        let profitVC = ProfitViewController(reactor: ProfitReactor(calculator: profitCalculator))
        let profitNav = UINavigationController(rootViewController: profitVC)
        profitVC.tabBarItem = UITabBarItem(
            title: "수익 계산",
            image: UIImage(systemName: "chart.line.uptrend.xyaxis"),
            selectedImage: UIImage(systemName: "chart.line.uptrend.xyaxis.circle.fill")
        )
        
        viewControllers = [additionalPurchaseNav, profitNav]
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        
        appearance.backgroundColor = .systemGray6
        
        appearance.shadowColor = .gray.withAlphaComponent(0.3)
        appearance.shadowImage = UIImage()
        
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.gray
        ]
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.tintColor
        ]
        
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = normalAttributes
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttributes
        
        tabBar.scrollEdgeAppearance = appearance
    }
    
}

#if DEBUG
import SwiftUI

#Preview {
    let mock = StockCalculatorImpl()
    let secondMock = ProfitCalculatorImpl()
    
    MainTabBarController(calculator: mock, profitCalculator: secondMock).toPreview()
}

#endif

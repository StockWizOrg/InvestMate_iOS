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
    private let stockManager: StockManagementUseCase
    
    public init(
        calculator: StockCalculatorUseCase,
        profitCalculator: ProfitCalculatorUseCase,
        stockManager: StockManagementUseCase
    ) {
        self.calculator = calculator
        self.profitCalculator = profitCalculator
        self.stockManager = stockManager
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
            title: String(localized: "Avg Down", bundle: .module),
            image: UIImage(systemName: "plus.circle"),
            selectedImage: UIImage(systemName: "plus.circle")
        )
        
        // 수익 계산 탭
        let profitVC = ProfitViewController(reactor: ProfitReactor(calculator: profitCalculator))
        let profitNav = UINavigationController(rootViewController: profitVC)
        profitVC.tabBarItem = UITabBarItem(
            title: String(localized: "Profit", bundle: .module),
            image: UIImage(systemName: "chart.line.uptrend.xyaxis"),
            selectedImage: UIImage(systemName: "chart.line.uptrend.xyaxis")
        )
        
        // 종목 관리 탭
        let stockListVC = StockListViewController(
            reactor: StockListReactor(stockManager: stockManager),
            calculator: calculator
        )
        let stockListNav = UINavigationController(rootViewController: stockListVC)
        stockListNav.tabBarItem = UITabBarItem(
            title: String(localized: "Holdings", bundle: .module),
            image: UIImage(systemName: "list.bullet"),
            selectedImage: UIImage(systemName: "list.bullet")
        )
        
        // 더보기 탭
        let moreMenuVC = MoreMenuViewController()
        let moreMenuNav = UINavigationController(rootViewController: moreMenuVC)
        moreMenuNav.tabBarItem = UITabBarItem(
            title: String(localized: "More", bundle: .module),
            image: UIImage(systemName: "ellipsis"),
            selectedImage: UIImage(systemName: "ellipsis")
        )
        
        viewControllers = [additionalPurchaseNav, profitNav, stockListNav, moreMenuNav]
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
    let thirdMock = MockStockManagement()
    
    MainTabBarController(
        calculator: mock,
        profitCalculator: secondMock,
        stockManager: thirdMock
    ).toPreview()
}

#endif

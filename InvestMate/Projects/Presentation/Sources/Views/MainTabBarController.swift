//
//  MainTabBarController.swift
//  Presentation
//
//  Created by 조호근 on 10/28/24.
//

import UIKit

import Domain
import RxSwift

public final class MainTabBarController: UITabBarController {
    
    let appID = "6741756312"
    
    private let calculator: StockCalculatorUseCase
    private let profitCalculator: ProfitCalculatorUseCase
    private let stockManager: StockManagementUseCase
    private let versionChecker: AppVersionCheckUseCase
    private let disposeBag = DisposeBag()
    
    public init(
        calculator: StockCalculatorUseCase,
        profitCalculator: ProfitCalculatorUseCase,
        stockManager: StockManagementUseCase,
        versionChecker: AppVersionCheckUseCase
    ) {
        self.calculator = calculator
        self.profitCalculator = profitCalculator
        self.stockManager = stockManager
        self.versionChecker = versionChecker
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewControllers()
        setupTabBarAppearance()
        checkAppVersion()
    }
    
    private func setupViewControllers() {
        let imageConfig = UIImage.SymbolConfiguration(weight: .regular)
        
        // 추가 매수 탭
        let additionalPurchaseVC = AdditionalPurchaseViewController(
            reactor: AdditionalPurchaseReactor(calculator: calculator),
            calculator: calculator
        )
        let additionalPurchaseNav = UINavigationController(rootViewController: additionalPurchaseVC)
        additionalPurchaseVC.tabBarItem = UITabBarItem(
            title: String(localized: "Avg Down", bundle: .module),
            image: UIImage(systemName: "plus.circle")?.withConfiguration(imageConfig),
            selectedImage: UIImage(systemName: "plus.circle")?.withConfiguration(imageConfig)
        )
        
        // 수익 계산 탭
        let profitVC = ProfitViewController(reactor: ProfitReactor(calculator: profitCalculator))
        let profitNav = UINavigationController(rootViewController: profitVC)
        profitVC.tabBarItem = UITabBarItem(
            title: String(localized: "Profit", bundle: .module),
            image: UIImage(systemName: "chart.line.uptrend.xyaxis")?.withConfiguration(imageConfig),
            selectedImage: UIImage(systemName: "chart.line.uptrend.xyaxis")?.withConfiguration(imageConfig)
        )
        
        // 종목 관리 탭
        let stockListVC = StockListViewController(
            reactor: StockListReactor(stockManager: stockManager),
            calculator: calculator
        )
        let stockListNav = UINavigationController(rootViewController: stockListVC)
        stockListNav.tabBarItem = UITabBarItem(
            title: String(localized: "Holdings", bundle: .module),
            image: UIImage(systemName: "list.bullet")?.withConfiguration(imageConfig),
            selectedImage: UIImage(systemName: "list.bullet")?.withConfiguration(imageConfig)
        )
        
        // 더보기 탭
        let moreMenuVC = MoreMenuViewController()
        let moreMenuNav = UINavigationController(rootViewController: moreMenuVC)
        moreMenuNav.tabBarItem = UITabBarItem(
            title: String(localized: "More", bundle: .module),
            image: UIImage(systemName: "ellipsis")?.withConfiguration(imageConfig),
            selectedImage: UIImage(systemName: "ellipsis")?.withConfiguration(imageConfig)
        )
        
        viewControllers = [additionalPurchaseNav, profitNav, stockListNav, moreMenuNav]
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .systemGray6
        appearance.shadowColor = UIColor.gray.withAlphaComponent(0.2)
        
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 11, weight: .regular),
            .foregroundColor: UIColor(hex: "999999")
        ]
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = normalAttributes
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(hex: "999999")
        
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 11, weight: .bold),
            .foregroundColor: UIColor(hex: "0F0F27")
        ]
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttributes
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(hex: "0F0F27")
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
    
    private func checkAppVersion() {
        versionChecker.checkAppVersion()
            .subscribe(onNext: { [weak self] status in
                if case let .updateAvailable(currentVersion, latestVersion) = status {
                    print("Update available: current=\(currentVersion), latest=\(latestVersion)")
                    DispatchQueue.main.async {
                        self?.showUpdateAlert(currentVersion: currentVersion, latestVersion: latestVersion)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func showUpdateAlert(currentVersion: String, latestVersion: String) {
        let alert = UIAlertController(
            title: String(localized: "Update Notice", bundle: .module),
            message: String(localized: "Update InvestMate to the latest version.", bundle: .module),
            preferredStyle: .alert
        )
        
        let updateAction = UIAlertAction(
            title: String(localized: "Update", bundle: .module),
            style: .default
        ) { [weak self] _ in
            self?.openAppStore()
        }
        
        let laterAction = UIAlertAction(
            title: String(localized: "Later", bundle: .module),
            style: .cancel
        )
        
        [updateAction, laterAction].forEach {
            $0.setValue(UIColor.systemBlue, forKey: "titleTextColor")
        }
        
        alert.addAction(laterAction)
        alert.addAction(updateAction)
        
        present(alert, animated: true)
    }
    
    private func openAppStore() {
        if let url = URL(string: "itms-apps://itunes.apple.com/app/id\(appID)") {
            UIApplication.shared.open(url)
        }
    }
    
}

#if DEBUG
import SwiftUI

#Preview {
    let mock = StockCalculatorImpl()
    let secondMock = ProfitCalculatorImpl()
    let thirdMock = MockStockManagement()
    let fourthMock = MockAppVersionCheck()
    
    MainTabBarController(
        calculator: mock,
        profitCalculator: secondMock,
        stockManager: thirdMock,
        versionChecker: fourthMock
    ).toPreview()
}

#endif

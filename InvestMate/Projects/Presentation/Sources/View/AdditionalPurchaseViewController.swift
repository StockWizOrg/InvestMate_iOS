//
//  AdditionalPurchaseViewController.swift
//  InvestMate
//
//  Created by 조호근 on 8/26/24.
//

import UIKit

public class AdditionalPurchaseViewController: UIViewController {
    
    private let holdingStockView = CustomStockView(title: "현재 보유")
    private let additionalStockView = CustomStockView(title: "추가 매수")
    private let finalStockView = CustomStockView(title: "최종 보유")
    private let dividerView = UIView()
    private let mainStackView = UIStackView()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setUI()
        setLayout()
    }
    
    private func setStyle() {
        self.view.backgroundColor = .systemGray6
        
        dividerView.configureDivider()
        
        mainStackView.addArrangedSubviews(holdingStockView, additionalStockView, dividerView, finalStockView)
        mainStackView.configureStackView(spacing: 20)
    }
    
    private func setUI() {
        self.view.addSubviews(mainStackView)
    }
    
    private func setLayout() {
        NSLayoutConstraint.activate([
            dividerView.leadingAnchor.constraint(equalTo:  mainStackView.leadingAnchor, constant: 16),
            dividerView.trailingAnchor.constraint(equalTo:  mainStackView.trailingAnchor, constant: -16),
            
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

#if DEBUG
import SwiftUI

#Preview {
    AdditionalPurchaseViewController().toPreview()
}
#endif

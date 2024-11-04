//
//  ProfitViewController.swift
//  Presentation
//
//  Created by 조호근 on 10/28/24.
//

import UIKit

public class ProfitViewController: UIViewController {
    
    private let purchasePriceLabel = UILabel()
    private let averagePriceView = LabeledTextFieldView(title: "평균단가", placeholder: "금액")
    private let sellQuantityLabel = UILabel()
    private let quantityView = LabeledTextFieldView(title: "수량", placeholder: "수량")
    private let salePriceLabel = UILabel()
    private let salePriceView = LabeledTextFieldView(title: "평균단가", placeholder: "금액")
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setUI()
        setLayout()
    }
    
    private func setStyle() {
        self.view.backgroundColor = .systemGray6
        
        purchasePriceLabel.configureLabel(title: "매수단가", ofSize: 20, weight: .bold)
        sellQuantityLabel.configureLabel(title: "매도수량", ofSize: 20, weight: .bold)
        salePriceLabel.configureLabel(title: "매도단가", ofSize: 20, weight: .bold)
    }
    
    private func setUI() {
        self.view.addSubviews(
            purchasePriceLabel,
            averagePriceView,
            sellQuantityLabel,
            quantityView,
            salePriceLabel,
            salePriceView
        )
    }
    
    private func setLayout() {
        NSLayoutConstraint.activate([
            purchasePriceLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            purchasePriceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            purchasePriceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // 평균단가 뷰
            averagePriceView.topAnchor.constraint(equalTo: purchasePriceLabel.bottomAnchor, constant: 8),
            averagePriceView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            averagePriceView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // 매도수량 레이블
            sellQuantityLabel.topAnchor.constraint(equalTo: averagePriceView.bottomAnchor, constant: 16),
            sellQuantityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            sellQuantityLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // 수량 뷰
            quantityView.topAnchor.constraint(equalTo: sellQuantityLabel.bottomAnchor, constant: 8),
            quantityView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            quantityView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // 매도단가 레이블
            salePriceLabel.topAnchor.constraint(equalTo: quantityView.bottomAnchor, constant: 16),
            salePriceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            salePriceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // 매도단가 뷰
            salePriceView.topAnchor.constraint(equalTo: salePriceLabel.bottomAnchor, constant: 8),
            salePriceView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            salePriceView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            salePriceView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
            
            
        ])
    }
    
}

#if DEBUG
import SwiftUI

#Preview {
    ProfitViewController().toPreview()
}
#endif

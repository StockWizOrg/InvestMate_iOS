//
//  ProfitViewController.swift
//  Presentation
//
//  Created by 조호근 on 10/28/24.
//

import UIKit

public class ProfitViewController: UIViewController {
    
    private let averagePriceView = LabeledTextFieldView(title: "매수단가", ofSize: 20, placeholder: "금액")
    private let quantityView = LabeledTextFieldView(title: "매도수량", ofSize: 20, placeholder: "수량")
    private let salePriceView = LabeledTextFieldView(title: "매도단가", ofSize: 20, placeholder: "금액")
    private let dividerView = UIView()
    private let profitResultView = ProfitResultView()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setUI()
        setLayout()
    }
    
    private func setStyle() {
        self.view.backgroundColor = .systemGray6
        
        dividerView.configureDivider()
    }
    
    private func setUI() {
        self.view.addSubviews(
            averagePriceView,
            quantityView,
            salePriceView,
            dividerView,
            profitResultView
        )
    }
    
    private func setLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            averagePriceView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 8),
            averagePriceView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            averagePriceView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            
            quantityView.topAnchor.constraint(equalTo: averagePriceView.bottomAnchor, constant: 16),
            quantityView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            quantityView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            
            salePriceView.topAnchor.constraint(equalTo: quantityView.bottomAnchor, constant: 16),
            salePriceView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            salePriceView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            
            dividerView.topAnchor.constraint(equalTo: salePriceView.bottomAnchor, constant: 20),
            dividerView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            dividerView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            
            profitResultView.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 20),
            profitResultView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            profitResultView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16)
            
        ])
    }
    
}

#if DEBUG
import SwiftUI

#Preview {
    ProfitViewController().toPreview()
}
#endif

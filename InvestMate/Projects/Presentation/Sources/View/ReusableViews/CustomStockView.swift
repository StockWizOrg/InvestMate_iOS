//
//  CustomStockView.swift
//  Presentation
//
//  Created by 조호근 on 10/10/24.
//

import UIKit

public final class CustomStockView: UIView {
    
    private let titleLabel = UILabel()
    private let averagePriceView = LabeledTextFieldView(title: "평균단가", placeholder: "금액")
    private let quantityView = LabeledTextFieldView(title: "수량", placeholder: "수량")
    private let totalPriceView = LabeledTextFieldView(title: "총 금액", placeholder: "금액")
    private let horizontalStackView = UIStackView()
    private let verticalStackView = UIStackView()
    
    init(title: String) {
        super.init(frame: .zero)
        
        setStyle(title: title)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    private func setStyle(title: String) {
        self.backgroundColor = .systemGray6
        
        titleLabel.configureLabel(title: title, ofSize: 20, weight: .bold)
        
        horizontalStackView.addArrangedSubviews(averagePriceView, quantityView)
        horizontalStackView.configureStackView(axis: .horizontal)
        
        verticalStackView.addArrangedSubviews(horizontalStackView, totalPriceView)
        verticalStackView.configureStackView(distribution: .fillEqually, spacing: 10)
    }
    
    private func setUI() {
        self.addSubviews(titleLabel, verticalStackView)
    }
    
    private func setLayout() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            
            verticalStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            verticalStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
}

#if DEBUG
import SwiftUI

#Preview {
    CustomStockView(title: "현재보유").toPreview()
        .frame(width: UIScreen.main.bounds.width, height: 200)
}
#endif


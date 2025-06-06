//
//  StockResultView.swift
//  Presentation
//
//  Created by 조호근 on 12/4/24.
//

import UIKit

import Domain

public final class StockResultView: UIView {
    
    private let titleLabel = UILabel()
    private let averagePriceTitle = UILabel()
    private let averagePriceLabel = ScrollableLabel()
    private let quantityTitle = UILabel()
    private let quantityLabel = ScrollableLabel(placeholder: String(localized: "Quantity", bundle: .module))
    private let totalPriceTitle = UILabel()
    private let totalPriceLabel = ScrollableLabel()
    
    private let averageStackView = UIStackView()
    private let quantityStackView = UIStackView()
    private let totalStackView = UIStackView()
    private let horizontalStackView = UIStackView()
    private let verticalStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setStyle()
        setUI()
        setLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension StockResultView {
    
    private func setStyle() {
        self.backgroundColor = .systemGray6
        
        titleLabel.configureTitleLabel(
            title: String(localized: "Final holdings", bundle: .module),
            ofSize: 20,
            weight: .bold
        )
        averagePriceTitle.configureTitleLabel(
            title: String(localized: "Average Price", bundle: .module),
            ofSize: 14,
            weight: .semibold
        )
        quantityTitle.configureTitleLabel(
            title: String(localized: "Quantity", bundle: .module),
            ofSize: 14,
            weight: .semibold
        )
        totalPriceTitle.configureTitleLabel(
            title: String(localized: "Total Amount", bundle: .module),
            ofSize: 14,
            weight: .semibold
        )
        
        [averagePriceLabel, quantityLabel, totalPriceLabel].forEach {
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
        }
        
        averageStackView.configureStackView()
        quantityStackView.configureStackView()
        totalStackView.configureStackView()
        horizontalStackView.configureStackView(axis: .horizontal, distribution: .fillEqually, spacing: 20)
        verticalStackView.configureStackView(distribution: .fillEqually, spacing: 10)
    }
    
    private func setUI() {
        averageStackView.addArrangedSubviews(
            averagePriceTitle,
            averagePriceLabel
        )
        
        quantityStackView.addArrangedSubviews(
            quantityTitle,
            quantityLabel
        )
        
        horizontalStackView.addArrangedSubviews(
            averageStackView,
            quantityStackView
        )
        
        totalStackView.addArrangedSubviews(
            totalPriceTitle,
            totalPriceLabel
        )
        
        verticalStackView.addArrangedSubviews(
            horizontalStackView,
            totalStackView
        )
        
        self.addSubviews(
            titleLabel,
            verticalStackView
        )
    }
    
    private func setLayout() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.heightAnchor.constraint(equalToConstant: 24),
            
            averagePriceLabel.heightAnchor.constraint(equalToConstant: 44),
            quantityLabel.heightAnchor.constraint(equalToConstant: 44),
            totalPriceLabel.heightAnchor.constraint(equalToConstant: 44),
            
            verticalStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            verticalStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    func setValues(averagePrice: String?, quantity: String?, totalPrice: String?) {
        averagePriceLabel.setText(averagePrice)
        quantityLabel.setText(quantity)
        totalPriceLabel.setText(totalPrice)
    }
}

#if DEBUG
import SwiftUI

#Preview {
    StockResultView().toPreview()
        .frame(width: UIScreen.main.bounds.width, height: 200)
}

#endif

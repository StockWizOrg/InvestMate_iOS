//
//  ProfitResultView.swift
//  Presentation
//
//  Created by 조호근 on 11/5/24.
//

import UIKit

final class ProfitResultView: UIView {
    
    private let titleLabel = UILabel()
    private let profitTitleLabel = UILabel()
    private let totalProfitLabel = ScrollableLabel()
    private let profitRateLabel = PaddedLabel()
    
    private let purchaseTitleLabel = UILabel()
    private let purchaseAmountLabel = ScrollableLabel()
    private let saleTitleLabel = UILabel()
    private let saleAmountLabel = ScrollableLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setStyle()
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyle() {
        self.backgroundColor = .systemGray6
        
        titleLabel.configureTitleLabel(
            title: String(localized: "Investment Result", bundle: .module),
            ofSize: 20,
            weight: .bold
        )
        profitTitleLabel.configureTitleLabel(
            title: String(localized: "Profit/Loss", bundle: .module),
            ofSize: 14,
            weight: .semibold
        )
        profitTitleLabel.numberOfLines = 1
        
        purchaseTitleLabel.configureTitleLabel(
            title: String(localized: "Purchase Amount", bundle: .module),
            ofSize: 14,
            weight: .semibold
        )
        saleTitleLabel.configureTitleLabel(
            title: String(localized: "Sale Amount", bundle: .module),
            ofSize: 14,
            weight: .semibold
        )
        
        [totalProfitLabel, purchaseAmountLabel, saleAmountLabel].forEach {
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
        }
        
        profitRateLabel.configureNumericLabel()
        profitRateLabel.textAlignment = .center
        profitRateLabel.textColor = .white
        profitRateLabel.isHidden = true
    }
    
    private func setUI() {
        addSubviews(
            titleLabel,
            profitTitleLabel,
            totalProfitLabel,
            profitRateLabel,
            purchaseTitleLabel,
            purchaseAmountLabel,
            saleTitleLabel,
            saleAmountLabel
        )
    }
    
    private func setLayout() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 24),
            
            profitTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            profitTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            profitTitleLabel.widthAnchor.constraint(equalToConstant: 80),
            
            totalProfitLabel.topAnchor.constraint(equalTo: profitTitleLabel.bottomAnchor, constant: 8),
            totalProfitLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            totalProfitLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            totalProfitLabel.heightAnchor.constraint(equalToConstant: 44),
            
            
            profitRateLabel.bottomAnchor.constraint(equalTo: profitTitleLabel.bottomAnchor),
            profitRateLabel.leadingAnchor.constraint(greaterThanOrEqualTo: profitTitleLabel.trailingAnchor, constant: 50),
            profitRateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            profitRateLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
            profitRateLabel.heightAnchor.constraint(equalToConstant: 30),
            
            purchaseTitleLabel.topAnchor.constraint(equalTo: totalProfitLabel.bottomAnchor, constant: 12),
            purchaseTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            purchaseAmountLabel.topAnchor.constraint(equalTo: purchaseTitleLabel.bottomAnchor, constant: 6),
            purchaseAmountLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            purchaseAmountLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            purchaseAmountLabel.heightAnchor.constraint(equalToConstant: 44),
            
            saleTitleLabel.topAnchor.constraint(equalTo: purchaseAmountLabel.bottomAnchor, constant: 12),
            saleTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            saleAmountLabel.topAnchor.constraint(equalTo: saleTitleLabel.bottomAnchor, constant: 6),
            saleAmountLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            saleAmountLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            saleAmountLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            saleAmountLabel.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func updateProfitRate(rate: Double) {
        profitRateLabel.isHidden = false
        profitRateLabel.text = "\(rate.toFormattedString())%"
        profitRateLabel.backgroundColor = rate >= 0 ? .systemRed : .systemBlue
    }
    
    func setProfitAmount(_ amount: String) {
        totalProfitLabel.setText(amount)
    }
    
    func setPurchaseAmount(_ amount: String) {
        purchaseAmountLabel.setText(amount)
    }
    
    func setSaleAmount(_ amount: String) {
        saleAmountLabel.setText(amount)
    }
    
    func hideProfitRate() {
        profitRateLabel.isHidden = true
    }
    
}

#if DEBUG
import SwiftUI

#Preview {
    let view = ProfitResultView()
    view.setProfitAmount("1,234,5671,234,5671,234,5671,2322233234,567")
    view.updateProfitRate(rate: -132331223212325.01)
    view.setPurchaseAmount("10,000,000")
    view.setSaleAmount("11,234,567")
    return view.toPreview()
        .frame(height: 300)
}
#endif

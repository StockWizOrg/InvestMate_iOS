//
//  StockCellContentView.swift
//  Presentation
//
//  Created by 조호근 on 12/21/24.
//

import UIKit

class StockCellContentView: UIView {

    private let titleLabel = UILabel()
    private let valueLabel = ScrollableLabel()
    
    init(title: String) {
        super.init(frame: .zero)
        setStyle(title: title)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setStyle(title: String) {
        layer.cornerRadius = 8
        clipsToBounds = true
        backgroundColor = .systemGray6
        
        titleLabel.configureTitleLabel(title: title, ofSize: 14, weight: .semibold, indent: 8)
        titleLabel.textColor = .systemGray
        
        valueLabel.backgroundColor = .clear
        valueLabel.alpha = 1
        valueLabel.configureRightAlignment()
        
    }
    
    private func setUI() {
        addSubviews(titleLabel, valueLabel)
    }
    
    private func setLayout() {
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            
            valueLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            valueLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 20),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            valueLabel.heightAnchor.constraint(equalToConstant: 44)
            
        ])
    }
    
    func setValue(_ value: String) {
        valueLabel.setText(value)
    }
    
}

#if DEBUG
import SwiftUI

#Preview {
    let view = StockCellContentView(title: "보유수량")
    view.setValue("100,29,101,20,291,20,29,1,20,29,,101,230")
    
    return view.toPreview()
        .frame(height: 100)
    
}

#endif

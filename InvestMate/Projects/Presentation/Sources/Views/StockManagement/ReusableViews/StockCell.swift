//
//  StockCell.swift
//  Presentation
//
//  Created by 조호근 on 12/22/24.
//

import UIKit

import Domain

class StockCell: UITableViewCell {
    
    static let identifier = "StockTableViewCell"
    
    private let stockNameLabel = UILabel()
    private let dividerView = UIView()
    private let menuButton = UIButton()
    private let quantityContentView = StockCellContentView(title: "보유수량")
    private let averagePriceContentView = StockCellContentView(title: "평균단가")
    private let totalContentView = StockCellContentView(title: "최종보유")
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setStyle()
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyle() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 8
        clipsToBounds = true
        
        stockNameLabel.font = .systemFont(ofSize: 20, weight: .bold)
        
        dividerView.configureDivider()
        
        menuButton.setImage(
            UIImage(
                systemName: "chevron.right",
                withConfiguration: UIImage.SymbolConfiguration(weight: .bold)
            ),
            for: .normal
        )
        menuButton.tintColor = .systemGray3
    }
    
    private func setUI() {
        contentView.addSubviews(
            stockNameLabel,
            menuButton,
            dividerView,
            quantityContentView,
            averagePriceContentView,
            totalContentView
        )
    }
    
    private func setLayout() {
        NSLayoutConstraint.activate([
            stockNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stockNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            menuButton.centerYAnchor.constraint(equalTo: stockNameLabel.centerYAnchor),
            menuButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            menuButton.widthAnchor.constraint(equalToConstant: 44),
            menuButton.heightAnchor.constraint(equalToConstant: 44),
            
            dividerView.topAnchor.constraint(equalTo: menuButton.bottomAnchor, constant: 8),
            dividerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dividerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            quantityContentView.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 16),
            quantityContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            quantityContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            quantityContentView.heightAnchor.constraint(equalToConstant: 44),
            
            averagePriceContentView.topAnchor.constraint(equalTo: quantityContentView.bottomAnchor, constant: 8),
            averagePriceContentView.leadingAnchor.constraint(equalTo: quantityContentView.leadingAnchor),
            averagePriceContentView.trailingAnchor.constraint(equalTo: quantityContentView.trailingAnchor),
            averagePriceContentView.heightAnchor.constraint(equalToConstant: 44),
            
            totalContentView.topAnchor.constraint(equalTo: averagePriceContentView.bottomAnchor, constant: 8),
            totalContentView.leadingAnchor.constraint(equalTo: quantityContentView.leadingAnchor),
            totalContentView.trailingAnchor.constraint(equalTo: quantityContentView.trailingAnchor),
            totalContentView.heightAnchor.constraint(equalToConstant: 44),
            totalContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    func configure(with stock: Stock) {
        stockNameLabel.text = stock.name
        quantityContentView.setValue("\(stock.quantity)")
        averagePriceContentView.setValue("\(stock.averagePrice)")
    }
}

#if DEBUG
import SwiftUI

#Preview {
    let view = StockCell()
    let sampleData = Stock.sample
    view.configure(with: sampleData)
    
    return ZStack {
        Color.green
        view.toPreview()
            .frame(width: 330, height: 240)
    }
}

#endif

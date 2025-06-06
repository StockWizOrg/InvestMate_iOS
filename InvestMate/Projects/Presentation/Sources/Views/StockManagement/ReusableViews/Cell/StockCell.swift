//
//  StockCell.swift
//  Presentation
//
//  Created by 조호근 on 12/22/24.
//

import UIKit

import Domain

import RxSwift

public final class StockCell: UITableViewCell {
    
    static let identifier = "StockTableViewCell"
    
    public var disposeBag = DisposeBag()
    private var stock: Stock?
    
    var menuButtonTap: Observable<Stock> {
        return menuButton.rx.tap
            .compactMap { [weak self] _ in self?.stock }
    }
    
    private let containerView = UIView()
    private let stockNameLabel = UILabel()
    private let dividerView = UIView()
    private let menuButton = UIButton()
    private let quantityContentView = StockCellContentView(title: String(localized: "Holding Quantity", bundle: .module))
    private let averagePriceContentView = StockCellContentView(title: String(localized: "Average Price", bundle: .module))
    private let totalContentView = StockCellContentView(title:  String(localized: "Total Amount1", bundle: .module))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setStyle()
        setUI()
        setLayout()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyle() {
        backgroundColor = .clear
        selectionStyle = .none
        
        containerView.backgroundColor = .systemBackground
        containerView.layer.cornerRadius = 8
        containerView.layer.masksToBounds = true
        
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
        contentView.addSubview(containerView)
        containerView.addSubviews(
            stockNameLabel,
            menuButton,
            dividerView,
            averagePriceContentView,
            quantityContentView,
            totalContentView
        )
    }
    
    private func setLayout() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            menuButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            menuButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            menuButton.widthAnchor.constraint(equalToConstant: 44),
            menuButton.heightAnchor.constraint(equalToConstant: 44),
            
            stockNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            stockNameLabel.centerYAnchor.constraint(equalTo: menuButton.centerYAnchor),
            
            dividerView.topAnchor.constraint(equalTo: menuButton.bottomAnchor, constant: 8),
            dividerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            dividerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            
            averagePriceContentView.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 16),
            averagePriceContentView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            averagePriceContentView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            averagePriceContentView.heightAnchor.constraint(equalToConstant: 44),
            
            quantityContentView.topAnchor.constraint(equalTo: averagePriceContentView.bottomAnchor, constant: 8),
            quantityContentView.leadingAnchor.constraint(equalTo: averagePriceContentView.leadingAnchor),
            quantityContentView.trailingAnchor.constraint(equalTo: averagePriceContentView.trailingAnchor),
            quantityContentView.heightAnchor.constraint(equalToConstant: 44),
            
            totalContentView.topAnchor.constraint(equalTo: quantityContentView.bottomAnchor, constant: 8),
            totalContentView.leadingAnchor.constraint(equalTo: quantityContentView.leadingAnchor),
            totalContentView.trailingAnchor.constraint(equalTo: quantityContentView.trailingAnchor),
            totalContentView.heightAnchor.constraint(equalToConstant: 44),
            totalContentView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }
    
    public func configure(with stock: Stock) {
        self.stock = stock
        
        stockNameLabel.text = stock.name
        quantityContentView.setValue("\(stock.quantity.toFormattedString())")
        averagePriceContentView.setValue("\(stock.averagePrice.toFormattedString())")
        totalContentView.setValue("\(stock.totalPrice.toFormattedString())")
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
            .frame(width: 330, height: 300)
    }
}

#endif

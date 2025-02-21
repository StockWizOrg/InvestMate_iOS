//
//  CustomStockView.swift
//  Presentation
//
//  Created by 조호근 on 10/10/24.
//

import UIKit
import Domain

import RxSwift

public final class CustomStockView: UIView {
    
    private let titleLabel = UILabel()
    private let averagePriceView = LabeledTextFieldView(
        title: String(localized: "Average Price", bundle: .module),
        placeholder: String(localized: "Amount", bundle: .module)
    )
    private let quantityView = LabeledTextFieldView(
        title: String(localized: "Quantity", bundle: .module),
        placeholder: String(localized: "Quantity", bundle: .module)
    )
    private let totalPriceView = LabeledTextFieldView(
        title: String(localized: "Total Amount", bundle: .module),
        placeholder: String(localized: "Amount", bundle: .module)
    )
    private let horizontalStackView = UIStackView()
    private let verticalStackView = UIStackView()
    
    private let calculator: StockCalculatorUseCase
    private let disposeBag = DisposeBag()
    
    var averagePriceObservable: Observable<String?> {
        return averagePriceView.textObservable
    }
    var quantityObservable: Observable<String?> {
        return quantityView.textObservable
    }
    var totalPriceObservable: Observable<String?> {
        return totalPriceView.textObservable
    }
    
    public init(title: String, calculator: StockCalculatorUseCase) {
        self.calculator = calculator
        super.init(frame: .zero)
        
        
        setStyle(title: title)
        setUI()
        setLayout()
        setupCalculation()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyle(title: String) {
        self.backgroundColor = .systemGray6
        
        titleLabel.configureTitleLabel(title: title, ofSize: 20, weight: .bold)
        
        horizontalStackView.addArrangedSubviews(averagePriceView, quantityView)
        horizontalStackView.configureStackView(axis: .horizontal, distribution: .fillEqually, spacing: 20)
        
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
            titleLabel.heightAnchor.constraint(equalToConstant: 24),
            
            verticalStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            verticalStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
        ])
    }
    
    func getTextFields() -> [LabeledTextFieldView] {
        return [averagePriceView, quantityView, totalPriceView]
    }
    
}

extension CustomStockView {
    
    func setValues(averagePrice: String?, quantity: String?, totalPrice: String?) {
        averagePriceView.setText(averagePrice)
        quantityView.setText(quantity)
        totalPriceView.setText(totalPrice)
    }
    
    private func setupCalculation() {
        let convertToDouble: (String?) -> Double? = { text in
            guard let text = text?.replacingOccurrences(of: ",", with: "") else { return nil }
            return Double(text)
        }
        
        let averagePrice = averagePriceObservable.map(convertToDouble)
        let quantity = quantityObservable.map(convertToDouble)
        let totalPrice = totalPriceObservable.map(convertToDouble)
        
        // 평단가 또는 수량이 비어있을 때 총 금액 초기화
        Observable.combineLatest(averagePrice, quantity)
            .subscribe(onNext: { [weak self] avgPrice, qty in
                if avgPrice == nil || qty == nil {
                    self?.totalPriceView.setText("")
                }
            })
            .disposed(by: disposeBag)
        
        // 평단가와 수량으로 총액 계산
        Observable.combineLatest(averagePrice, quantity)
            .filter { avgPrice, qty in
                guard let avgPrice = avgPrice,
                      let qty = qty else { return false }
                return avgPrice > 0 && qty > 0
            }
            .flatMap { [weak self] avgPrice, qty -> Observable<Double> in
                guard let self = self,
                      let avgPrice = avgPrice,
                      let qty = qty else { return .empty() }
                return self.calculator.calculateTotalPrice(averagePrice: avgPrice, quantity: qty)
            }
            .map { $0.toFormattedString() }
            .subscribe(onNext: { [weak self] total in
                self?.totalPriceView.setText(total)
            })
            .disposed(by: disposeBag)
        
        // 평단가와 총액으로 수량 계산
        Observable.combineLatest(averagePrice, totalPrice)
            .filter { avgPrice, total in
                guard let avgPrice = avgPrice,
                      let total = total else { return false }
                return avgPrice > 0 && total > 0
            }
            .flatMap { [weak self] avgPrice, total -> Observable<Double> in
                guard let self = self,
                      let avgPrice = avgPrice,
                      let total = total else { return .empty() }
                return self.calculator.calculateQuantity(averagePrice: avgPrice, totalPrice: total)
            }
            .map { $0.toFormattedString() }
            .subscribe(onNext: { [weak self] qty in
                self?.quantityView.setText(qty)
            })
            .disposed(by: disposeBag)
    }
    
}

#if DEBUG
import SwiftUI
import Domain

#Preview {
    CustomStockView(title: "현재보유", calculator: StockCalculatorImpl()).toPreview()
        .frame(width: UIScreen.main.bounds.width, height: 200)
}
#endif

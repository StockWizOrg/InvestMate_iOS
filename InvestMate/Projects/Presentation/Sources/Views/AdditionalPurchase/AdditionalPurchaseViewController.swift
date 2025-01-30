//
//  AdditionalPurchaseViewController.swift
//  InvestMate
//
//  Created by 조호근 on 8/26/24.
//

import UIKit
import Domain

import ReactorKit
import RxSwift

public class AdditionalPurchaseViewController: UIViewController {
    
    private let holdingStockView: CustomStockView
    private let additionalStockView: CustomStockView
    private let finalStockView = StockResultView()
    private let dividerView = UIView()
    private let topStackView = UIStackView()
    private let dividerContainer = UIView()
    private let mainStackView = UIStackView()
    
    public var disposeBag = DisposeBag()
    
    public init(reactor: AdditionalPurchaseReactor, calculator: StockCalculatorUseCase) {
        self.holdingStockView = CustomStockView(title: "현재 보유", calculator: calculator)
        self.additionalStockView = CustomStockView(title: "추가 매수", calculator: calculator)
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        setStyle()
        setUI()
        setLayout()
    }
    
    private func setStyle() {
        self.title = "추가 매수"
        self.view.backgroundColor = .systemGray6
        
        dividerView.configureDivider()
        
        topStackView.configureStackView(distribution: .fillEqually, spacing: 12)
        
        mainStackView.configureStackView(
            distribution: .fill,
            spacing: 12
        )
    }
    
    private func setUI() {
        topStackView.addArrangedSubviews(holdingStockView, additionalStockView)
        dividerContainer.addSubview(dividerView)
        mainStackView.addArrangedSubviews(topStackView, dividerContainer, finalStockView)
        
        self.view.addSubviews(mainStackView)
    }
    
    private func setLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            
            topStackView.heightAnchor.constraint(equalTo: finalStockView.heightAnchor, multiplier: 2),
            
            dividerContainer.heightAnchor.constraint(equalToConstant: 1),
            
            dividerView.leadingAnchor.constraint(equalTo: dividerContainer.leadingAnchor, constant: 16),
            dividerView.trailingAnchor.constraint(equalTo: dividerContainer.trailingAnchor, constant: -16),
            dividerView.centerYAnchor.constraint(equalTo: dividerContainer.centerYAnchor)
            
        ])
    }
    
}

extension AdditionalPurchaseViewController: ReactorView {
    
    public func bind(reactor: AdditionalPurchaseReactor) {
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    private func bindInput(reactor: AdditionalPurchaseReactor) {
        // 현재 보유 입력 바인딩
        holdingStockView.averagePriceObservable
            .map { priceStr -> Double? in
                guard let str = priceStr, !str.isEmpty else { return nil }
                let clean = str.replacingOccurrences(of: ",", with: "")
                return Double(clean)
            }
            .map { Reactor.Action.updateHoldingPrice($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        holdingStockView.quantityObservable
            .map { qtyStr -> Double? in
                guard let str = qtyStr, !str.isEmpty else { return nil }
                let clean = str.replacingOccurrences(of: ",", with: "")
                return Double(clean)
            }
            .map { Reactor.Action.updateHoldingQuantity($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        holdingStockView.totalPriceObservable
            .map { totalStr -> Double? in
                guard let str = totalStr, !str.isEmpty else { return nil }
                let clean = str.replacingOccurrences(of: ",", with: "")
                return Double(clean)
            }
            .map { Reactor.Action.updateHoldingTotal($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 추가 매수 입력 바인딩
        additionalStockView.averagePriceObservable
            .map { priceStr -> Double? in
                guard let str = priceStr, !str.isEmpty else { return nil }
                let clean = str.replacingOccurrences(of: ",", with: "")
                return Double(clean)
            }
            .map { Reactor.Action.updateAdditionalPrice($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        additionalStockView.quantityObservable
            .map { qtyStr -> Double? in
                guard let str = qtyStr, !str.isEmpty else { return nil }
                let clean = str.replacingOccurrences(of: ",", with: "")
                return Double(clean)
            }
            .map { Reactor.Action.updateAdditionalQuantity($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        additionalStockView.totalPriceObservable
            .map { totalStr -> Double? in
                guard let str = totalStr, !str.isEmpty else { return nil }
                let clean = str.replacingOccurrences(of: ",", with: "")
                return Double(clean)
            }
            .map { Reactor.Action.updateAdditionalTotal($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: AdditionalPurchaseReactor) {
        // 현재 보유
        reactor.state.map(\.holding)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] info in
                self?.holdingStockView.setValues(
                    averagePrice: info.averagePrice?.toFormattedString(),
                    quantity: info.quantity?.toFormattedString(),
                    totalPrice: info.totalPrice?.toFormattedString()
                )
            })
            .disposed(by: disposeBag)
        
        // 추가 매수
        reactor.state.map(\.additional)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] info in
                self?.additionalStockView.setValues(
                    averagePrice: info.averagePrice?.toFormattedString(),
                    quantity: info.quantity?.toFormattedString(),
                    totalPrice: info.totalPrice?.toFormattedString()
                )
            })
            .disposed(by: disposeBag)
        
        // 최종 보유
        reactor.state.map(\.final)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] info in
                if let info = info {
                    self?.finalStockView.setValues(
                        averagePrice: info.averagePrice?.toFormattedString(),
                        quantity: info.quantity?.toFormattedString(),
                        totalPrice: info.totalPrice?.toFormattedString()
                    )
                } else {
                    self?.finalStockView.setValues(
                        averagePrice: nil,
                        quantity: nil,
                        totalPrice: nil
                    )
                }
            })
            .disposed(by: disposeBag)
    }
    
}

#if DEBUG
import SwiftUI

#Preview {
    AdditionalPurchaseViewController(reactor: AdditionalPurchaseReactor(calculator: StockCalculatorImpl()), calculator: StockCalculatorImpl()).toPreview()
}
#endif

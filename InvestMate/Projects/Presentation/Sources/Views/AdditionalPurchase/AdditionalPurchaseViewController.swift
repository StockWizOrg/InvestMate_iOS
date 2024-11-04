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
    private let finalStockView: CustomStockView
    private let dividerView = UIView()
    private let mainStackView = UIStackView()
    
    public var disposeBag = DisposeBag()
    
    public init(reactor: AdditionalPurchaseReactor, calculator: StockCalculatorUseCase) {
        self.holdingStockView = CustomStockView(title: "현재 보유", calculator: calculator)
        self.additionalStockView = CustomStockView(title: "추가 매수", calculator: calculator)
        self.finalStockView = CustomStockView(title: "최종 보유", isReadOnly: true, calculator: calculator)
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setUI()
        setLayout()
    }
    
    private func setStyle() {
        self.view.backgroundColor = .systemGray6
        
        dividerView.configureDivider()
        
        mainStackView.addArrangedSubviews(holdingStockView, additionalStockView, dividerView, finalStockView)
        mainStackView.configureStackView(
            distribution: .fill,
            spacing: 12
        )
    }
    
    private func setUI() {
        self.view.addSubviews(mainStackView)
    }
    
    private func setLayout() {
        NSLayoutConstraint.activate([
            holdingStockView.heightAnchor.constraint(equalToConstant: 200),
            additionalStockView.heightAnchor.constraint(equalToConstant: 200),
            finalStockView.heightAnchor.constraint(equalToConstant: 200),
            
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            dividerView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor)
        ])
    }
    
}

extension AdditionalPurchaseViewController: ReactorView {
    
    public func bind(reactor: AdditionalPurchaseReactor) {
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    private func bindInput(reactor: AdditionalPurchaseReactor) {
        Observable.combineLatest(
            holdingStockView.averagePriceObservable,
            holdingStockView.quantityObservable,
            additionalStockView.averagePriceObservable,
            additionalStockView.quantityObservable
        )
        .map { holdingPrice, holdingQty, additionalPrice, additionalQty in
            // 전처리
            let cleanHoldingPrice = holdingPrice?.replacingOccurrences(of: ",", with: "")
            let cleanHoldingQty = holdingQty?.replacingOccurrences(of: ",", with: "")
            let cleanAdditionalPrice = additionalPrice?.replacingOccurrences(of: ",", with: "")
            let cleanAdditionalQty = additionalQty?.replacingOccurrences(of: ",", with: "")
            
            // 모든 값을 하나의 Action으로 변환
            return AdditionalPurchaseReactor.Action.updateBoth(
                holdingPrice: Double(cleanHoldingPrice ?? ""),
                holdingQuantity: Double(cleanHoldingQty ?? ""),
                additionalPrice: Double(cleanAdditionalPrice ?? ""),
                additionalQuantity: Double(cleanAdditionalQty ?? "")
            )
        }
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

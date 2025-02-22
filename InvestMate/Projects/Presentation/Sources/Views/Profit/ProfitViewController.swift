//
//  ProfitViewController.swift
//  Presentation
//
//  Created by 조호근 on 10/28/24.
//

import UIKit
import Domain

import ReactorKit
import RxSwift

public class ProfitViewController: UIViewController, TextFieldNavigatable {
    
    public var disposeBag = DisposeBag()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let averagePriceView = LabeledTextFieldView(
        title: String(localized: "Purchase Price", bundle: .module),
        ofSize: 20,
        placeholder: String(localized: "Amount", bundle: .module)
    )
    private let quantityView = LabeledTextFieldView(
        title: String(localized: "Sale Quantity", bundle: .module),
        ofSize: 20,
        placeholder: String(localized: "Quantity", bundle: .module)
    )
    private let salePriceView = LabeledTextFieldView(
        title: String(localized: "Sale Price", bundle: .module),
        ofSize: 20,
        placeholder: String(localized: "Amount", bundle: .module)
    )
    private let dividerView = UIView()
    private let profitResultView = ProfitResultView()
    
    var textFields: [LabeledTextFieldView] {
        return [averagePriceView, quantityView, salePriceView]
    }
    
    public init(reactor: ProfitReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        setupTextFieldNavigation()
        setStyle()
        setUI()
        setLayout()
    }
    
    private func setStyle() {
        self.title = String(localized: "Profit", bundle: .module)
        self.view.backgroundColor = .systemGray6
        scrollView.showsVerticalScrollIndicator = false
        
        dividerView.configureDivider()
    }
    
    private func setUI() {
        view.addSubviews(scrollView)
        scrollView.addSubviews(contentView)
        
        contentView.addSubviews(
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
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            averagePriceView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            averagePriceView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            averagePriceView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            quantityView.topAnchor.constraint(equalTo: averagePriceView.bottomAnchor, constant: 16),
            quantityView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            quantityView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            salePriceView.topAnchor.constraint(equalTo: quantityView.bottomAnchor, constant: 16),
            salePriceView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            salePriceView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            dividerView.topAnchor.constraint(equalTo: salePriceView.bottomAnchor, constant: 20),
            dividerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dividerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            profitResultView.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 20),
            profitResultView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            profitResultView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            profitResultView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
            
        ])
    }
    
}

extension ProfitViewController: ReactorView {
    
    public func bind(reactor: ProfitReactor) {
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }
    
    private func bindInput(reactor: ProfitReactor) {
        Observable.combineLatest(
            averagePriceView.textObservable,
            quantityView.textObservable,
            salePriceView.textObservable
        )
        .map { avgPrice, qty, salePrice in
            let cleanAvgPrice = avgPrice?.replacingOccurrences(of: ",", with: "")
            let cleanQty = qty?.replacingOccurrences(of: ",", with: "")
            let cleanSalePrice = salePrice?.replacingOccurrences(of: ",", with: "")
            
            return ProfitReactor.Action.update(
                averagePrice: Double(cleanAvgPrice ?? ""),
                quantity: Double(cleanQty ?? ""),
                salePrice: Double(cleanSalePrice ?? "")
            )
        }
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: ProfitReactor) {
        reactor.state.map(\.profitInfo)
            .subscribe(onNext: { [weak self] info in
                // 수익률 업데이트
                if let rate = info.profitRate {
                    self?.profitResultView.updateProfitRate(rate: rate)
                } else {
                    self?.profitResultView.hideProfitRate()
                }
                
                // 총 손익 업데이트
                self?.profitResultView.setProfitAmount(
                    info.totalProfit?.toFormattedString() ?? ""
                )
                
                // 매수금액 업데이트
                self?.profitResultView.setPurchaseAmount(
                    info.purchaseAmount?.toFormattedString() ?? ""
                )
                
                // 매도금액 업데이트
                self?.profitResultView.setSaleAmount(
                    info.saleAmount?.toFormattedString() ?? ""
                )
            })
            .disposed(by: disposeBag)
    }
    
}

#if DEBUG
import SwiftUI

#Preview {
    ProfitViewController(
        reactor: ProfitReactor(calculator: ProfitCalculatorImpl())
    ).toPreview()
}
#endif

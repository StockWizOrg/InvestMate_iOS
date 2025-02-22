//
//  CreateStockViewController.swift
//  Presentation
//
//  Created by 조호근 on 12/24/24.
//

import UIKit
import Domain

import ReactorKit
import RxSwift

final class CreateStockViewController: UIViewController, TextFieldNavigatable {
    
    private let mode: CreateStockReactor.Mode
    
    public var disposeBag = DisposeBag()
    
    private let nameView = LabeledTextFieldView(
        title: String(localized: "Name", bundle: .module),
        placeholder: String(localized: "Enter Name", bundle: .module),
        type: .name
    )
    private let dividerView = UIView()
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
    private let confirmButton = UIButton()
    
    var textFields: [LabeledTextFieldView] {
        return [nameView, averagePriceView, quantityView, totalPriceView]
    }
    
    init(reactor: CreateStockReactor, mode: CreateStockReactor.Mode = .create) {
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        setupTextFieldNavigation()
        setStyle()
        setUI()
        setLayout()
        configureNavigationTitle()
        configureConfirmButton()
        
        if case .edit(let stock) = mode {
            nameView.setText(stock.name)
            reactor?.action.onNext(.setInitialStock(stock))
        }
    }
    
    private func setStyle() {
        view.backgroundColor = .systemGray6
        
        dividerView.configureDivider()
    }
    
    private func configureNavigationTitle() {
        title = mode == .create ? String(localized: "Add Stock", bundle: .module) : String(localized: "Edit Stock", bundle: .module)
    }
    
    private func configureConfirmButton() {
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.baseForegroundColor = .white
        config.baseBackgroundColor = .black
        
        let buttonTitle = mode == .create ? "Add" : "Edit"
        let attributes =  AttributeContainer([
            .font: UIFont.systemFont(ofSize: 16, weight: .semibold)
        ])
        
        config.attributedTitle = AttributedString(buttonTitle, attributes: attributes)
        confirmButton.configuration = config
    }
    
    private func setUI() {
        view.addSubviews(
            nameView,
            dividerView,
            averagePriceView,
            quantityView,
            totalPriceView,
            confirmButton
        )
    }
    
    private func setLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            nameView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            nameView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            nameView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            
            dividerView.topAnchor.constraint(equalTo: nameView.bottomAnchor, constant: 16),
            dividerView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            dividerView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            
            averagePriceView.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 16),
            averagePriceView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            averagePriceView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            
            quantityView.topAnchor.constraint(equalTo: averagePriceView.bottomAnchor, constant: 16),
            quantityView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            quantityView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            
            totalPriceView.topAnchor.constraint(equalTo: quantityView.bottomAnchor, constant: 16),
            totalPriceView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            totalPriceView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            
            confirmButton.topAnchor.constraint(equalTo: totalPriceView.bottomAnchor, constant: 30),
            confirmButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            confirmButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            confirmButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
}

extension CreateStockViewController: ReactorView {
    
    func bind(reactor: CreateStockReactor) {
        bindInput(reactor: reactor)
        bindOutput(reactor: reactor)
    }

    private func bindInput(reactor: CreateStockReactor) {
        nameView.textObservable
            .map { Reactor.Action.updateName($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        averagePriceView.textObservable
            .map { Reactor.Action.updateAveragePrice($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        quantityView.textObservable
            .map { Reactor.Action.updateQuantity($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        totalPriceView.textObservable
            .map { Reactor.Action.updateTotalPrice($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        confirmButton.rx.tap
            .map { Reactor.Action.create }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    private func bindOutput(reactor: CreateStockReactor) {
        reactor.state.map(\.averagePrice)
            .map { $0?.toFormattedString() }
            .bind { [weak self] in
                self?.averagePriceView.setText($0)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map(\.quantity)
            .map { $0?.toFormattedString() }
            .bind { [weak self] in
                self?.quantityView.setText($0)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map(\.totalPrice)
            .map { $0?.toFormattedString() }
            .bind { [weak self] in
                self?.totalPriceView.setText($0)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map(\.isValid)
            .bind(to: confirmButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        reactor.state.map(\.isComplete)
            .filter { $0 }
            .bind { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
}

#if DEBUG
import SwiftUI

class MockStockListRefreshDelegate: StockListRefreshDelegate {
    func refreshStockList() {
        print("Mock refreshStockList called.")
    }
}

#Preview {
    CreateStockViewController(
        reactor: CreateStockReactor(
            stockManager: MockStockManagement(),
            calculator: StockCalculatorImpl(),
            refreshDelegate: MockStockListRefreshDelegate()
        )
    ).toPreview()
    
}

#endif


//
//  CreateStockReactor.swift
//  Presentation
//
//  Created by 조호근 on 12/24/24.
//

import Domain

import ReactorKit
import RxSwift

public protocol StockListRefreshDelegate: AnyObject {
    func refreshStockList()
}

public final class CreateStockReactor: Reactor {
    
    private weak var refreshDelegate: StockListRefreshDelegate?
    
    enum Mode {
        case create
        case edit(Stock)
    }
    
    public enum Action {
        case setInitialStock(Stock?)
        case updateName(String)
        case updateAveragePrice(String?)
        case updateQuantity(String?)
        case updateTotalPrice(String?)
        case create
    }
    
    public enum Mutation {
        case setName(String)
        case setStock(averagePrice: Double?, quantity: Double?, totalPrice: Double?)
        case setIsValid(Bool)
        case createComplete
        case setInitialValues(Stock)
    }
    
    public struct State {
        var name: String = ""
        var averagePrice: Double?
        var quantity: Double?
        var totalPrice: Double?
        var isValid: Bool = false
        var isComplete: Bool = false
    }
    
    public let initialState: State
    private let stockManager: StockManagementUseCase
    private let calculator: StockCalculatorUseCase
    private let mode: Mode
    
    init(
        stockManager: StockManagementUseCase,
        calculator: StockCalculatorUseCase,
        mode: Mode = .create,
        refreshDelegate: StockListRefreshDelegate
    ) {
        self.initialState = State()
        self.stockManager = stockManager
        self.calculator = calculator
        self.mode = mode
        self.refreshDelegate = refreshDelegate
        
        if case .edit(let stock) = mode {
            action.onNext(.setInitialStock(stock))
        }
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .setInitialStock(stock):
            guard let stock = stock else { return .empty() }
            return .just(.setInitialValues(stock))
            
        case let .updateName(name):
            return .concat([
                .just(.setName(name)),
                validateInput(name: name)
            ])
            
        case let .updateAveragePrice(price):
            let priceValue = convertToDouble(price)
            
            if let price = priceValue, let quantity = currentState.quantity {
                return calculator.calculateTotalPrice(averagePrice: price, quantity: quantity)
                    .map { total in
                            .setStock(averagePrice: price, quantity: quantity, totalPrice: total)
                    }
            }
            return .just(.setStock(averagePrice: priceValue, quantity: currentState.quantity, totalPrice: nil))
            
        case let .updateQuantity(quantity):
            let quantityValue = convertToDouble(quantity)
            
            if let price = currentState.averagePrice, let quantity = quantityValue {
                return calculator.calculateTotalPrice(averagePrice: price, quantity: quantity)
                    .map { total in
                            .setStock(averagePrice: price, quantity: quantity, totalPrice: total)
                    }
            }
            return .just(.setStock(averagePrice: currentState.averagePrice, quantity: quantityValue, totalPrice: nil))
            
        case let .updateTotalPrice(total):
            let totalValue = convertToDouble(total)
            
            if let price = currentState.averagePrice, let total = totalValue {
                return calculator.calculateQuantity(averagePrice: price, totalPrice: total)
                    .map { quantity in
                            .setStock(averagePrice: price, quantity: quantity, totalPrice: total)
                    }
            }
            return .just(.setStock(averagePrice: currentState.averagePrice, quantity: nil, totalPrice: totalValue))
            
        case .create:
            guard let price = currentState.averagePrice,
                  let quantity = currentState.quantity,
                  !currentState.name.isEmpty else {
                print("❌ 유효성 검사 실패")
                print("- 이름: \(currentState.name)")
                print("- 가격: \(String(describing: currentState.averagePrice))")
                print("- 수량: \(String(describing: currentState.quantity))")
                return .empty()
            }
            
            switch mode {
            case .create:
                print("✅ 새로운 주식 생성")
                print("- 이름: \(currentState.name)")
                print("- 가격: \(price)")
                print("- 수량: \(quantity)")
                return stockManager.addStock(
                    name: currentState.name,
                    averagePrice: price,
                    quantity: quantity
                )
                .do(onNext: { [weak self] _ in
                    self?.refreshDelegate?.refreshStockList()
                })
                .map { _ in .createComplete }
                
            case .edit(let stock):
                print("✅ 주식 정보 수정")
                print("- ID: \(stock.id)")
                print("- 이름: \(currentState.name)")
                print("- 가격: \(price)")
                print("- 수량: \(quantity)")
                return stockManager.updateStock(
                    id: stock.id,
                    name: currentState.name,
                    averagePrice: price,
                    quantity: quantity
                )
                .do(onNext: { [weak self] _ in
                    self?.refreshDelegate?.refreshStockList()
                })
                .map { _ in .createComplete }
            }
            
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setName(name):
            newState.name = name
            
        case let .setStock(price, quantity, total):
            newState.averagePrice = price
            newState.quantity = quantity
            newState.totalPrice = total
            newState.isValid = !newState.name.isEmpty &&
                                price != nil && quantity != nil &&
                                price! > 0 && quantity! > 0
            
        case let .setIsValid(isValid):
            newState.isValid = isValid
            
        case .createComplete:
            newState.isComplete = true
            
        case let .setInitialValues(stock):
            newState.name = stock.name
            newState.averagePrice = stock.averagePrice
            newState.quantity = stock.quantity
            newState.totalPrice = stock.averagePrice * stock.quantity
            newState.isValid = true
        }
        
        return newState
    }
    
}

extension CreateStockReactor {
    
    private func convertToDouble(_ value: String?) -> Double? {
        guard let value = value else { return nil }
        let cleaned = value.replacingOccurrences(of: ",", with: "")
        return Double(cleaned)
    }
    
    private func validateInput(name: String) -> Observable<Mutation> {
        let isValid = !name.isEmpty &&
                        currentState.averagePrice != nil &&
                        currentState.quantity != nil &&
                        currentState.averagePrice! > 0 &&
                        currentState.quantity! > 0
        return .just(.setIsValid(isValid))
    }
    
}

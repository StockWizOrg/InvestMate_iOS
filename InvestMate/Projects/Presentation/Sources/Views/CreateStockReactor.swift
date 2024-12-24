//
//  CreateStockReactor.swift
//  Presentation
//
//  Created by 조호근 on 12/24/24.
//

import Foundation
import Domain

import ReactorKit
import RxSwift

final class CreateStockReactor: Reactor {
    
    enum Action {
        case updateName(String)
        case updateAveragePrice(String?)
        case updateQuantity(String?)
        case updateTotalPrice(String?)
        case create
    }
    
    enum Mutation {
        case setName(String)
        case setStock(averagePrice: Double?, quantity: Double?, totalPrice: Double?)
        case setIsValid(Bool)
        case createComplete
    }
    
    struct State {
        var name: String = ""
        var averagePrice: Double?
        var quantity: Double?
        var totalPrice: Double?
        var isValid: Bool = false
        var shouldDismiss: Bool = false
    }
    
    let initialState: State
    private let stockManager: StockManagementUseCase
    private let calculator: StockCalculatorUseCase
    
    init(stockManager: StockManagementUseCase, calculator: StockCalculatorUseCase) {
        self.initialState = State()
        self.stockManager = stockManager
        self.calculator = calculator
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
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
                return .empty()
            }
            
            return stockManager.addStock(
                name: currentState.name,
                averagePrice: price,
                quantity: quantity
            )
            .map { _ in .createComplete }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
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
            newState.shouldDismiss = true
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

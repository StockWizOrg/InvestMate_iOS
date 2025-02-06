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

public protocol StockListRefreshDelegate: AnyObject {
    func refreshStockList()
}

public final class CreateStockReactor: Reactor {
    
    private weak var refreshDelegate: StockListRefreshDelegate?
    
    enum Mode: Equatable {
        case create
        case edit(Stock)
    }
    
    public enum Action {
        case setInitialStock(Stock?)
        case updateName(String?)
        case updateAveragePrice(String?)
        case updateQuantity(String?)
        case updateTotalPrice(String?)
        case create
    }
    
    public enum Mutation {
        case setName(String?)
        case setStock(averagePrice: Double?, quantity: Double?, totalPrice: Double?)
        case setIsValid(Bool)
        case createComplete
        case setInitialValues(Stock)
    }
    
    public struct State {
        var name: String?
        var averagePrice: Double?
        var quantity: Double?
        var totalPrice: Double?
        var isValid: Bool = false
        var isComplete: Bool = false
        var originalStock: Stock?
    }
    
    public let initialState: State
    private let stockManager: StockManagementUseCase
    private let calculator: StockCalculatorUseCase
    private let mode: Mode
    private var editingStockId: UUID?
    
    init(
        stockManager: StockManagementUseCase,
        calculator: StockCalculatorUseCase,
        mode: Mode = .create,
        refreshDelegate: StockListRefreshDelegate
    ) {
        self.stockManager = stockManager
        self.calculator = calculator
        self.mode = mode
        self.refreshDelegate = refreshDelegate
        
        if case .edit(let stock) = mode {
            self.editingStockId = stock.id
            self.initialState = State(
                name: stock.name,
                averagePrice: stock.averagePrice,
                quantity: stock.quantity,
                totalPrice: stock.totalPrice,
                originalStock: stock
            )
        } else {
            self.initialState = State()
        }
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .setInitialStock(stock):
            guard let stock = stock else { return .empty() }
            return .concat([
                .just(.setName(stock.name)),
                .just(.setStock(
                    averagePrice: stock.averagePrice,
                    quantity: stock.quantity,
                    totalPrice: stock.totalPrice
                ))
            ])
            
        case let .updateName(name):
            return .just(.setName(name))
            
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
                  let name = currentState.name,
                  !name.isEmpty else {
                print("❌ 유효성 검사 실패")
                print("- 이름: \(String(describing: currentState.name))")
                print("- 가격: \(String(describing: currentState.averagePrice))")
                print("- 수량: \(String(describing: currentState.quantity))")
                return .empty()
            }
            
            switch mode {
            case .create:
                print("✅ 새로운 주식 생성")
                print("- 이름: \(name)")
                print("- 가격: \(price)")
                print("- 수량: \(quantity)")
                return stockManager.addStock(
                    name: name,
                    averagePrice: price,
                    quantity: quantity
                )
                .do(onNext: { [weak self] _ in
                    self?.refreshDelegate?.refreshStockList()
                })
                .map { _ in .createComplete }
                
            case .edit:
                guard let id = editingStockId else { return .empty() }
                print("⚙️ 주식 정보 수정")
                print("- ID: \(id)")
                print("- 이름: \(name)")
                print("- 가격: \(price)")
                print("- 수량: \(quantity)")
                return stockManager.updateStock(
                    id: id,
                    name: name,
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
            newState.isValid = validateStockInput(
                name: name,
                price: state.averagePrice,
                quantity: state.quantity,
                originalStock: state.originalStock
            )
            
        case let .setStock(price, quantity, total):
            newState.averagePrice = price
            newState.quantity = quantity
            newState.totalPrice = total
            newState.isValid = validateStockInput(
                name: newState.name,
                price: price,
                quantity: quantity,
                originalStock: newState.originalStock
            )
            
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
    
    private func validateStockInput(
        name: String?,
        price: Double?,
        quantity: Double?,
        originalStock: Stock?
    ) -> Bool {
        guard let name = name, !name.isEmpty,
              let price = price, price > 0,
              let quantity = quantity, quantity > 0 else {
            return false
        }
        
        if let original = originalStock {
            // 수정 모드: 값이 변경되었고 유효한 값인 경우만 true
            let hasChanges = name != original.name ||
            price != original.averagePrice ||
            quantity != original.quantity
            
            return hasChanges
        } else {
            // 생성 모드: 유효한 값인 경우 true
            return true
        }
    }
    
}

//
//  ProfitReactor.swift
//  Presentation
//
//  Created by 조호근 on 12/6/24.
//

import Domain

import ReactorKit
import RxSwift

public final class ProfitReactor: Reactor {
    
    public enum Action {
        case update(averagePrice: Double?, quantity: Double?, salePrice: Double?)
    }
    
    public enum Mutation {
        case setProfitInfo(ProfitInfoState)
    }
    
    public struct State {
        var profitInfo: ProfitInfoState
    }
    
    public let initialState: State
    private let calculator: ProfitCalculatorUseCase
    
    public init(calculator: ProfitCalculatorUseCase) {
        self.calculator = calculator
        self.initialState = State(profitInfo: ProfitInfoState())
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
        case let .update(averagePrice, quantity, salePrice):
            
            if let avgPrice = averagePrice,
               let qty = quantity,
               let salePrice = salePrice {
                
                return Observable.zip(
                    calculator.calculateProfit(
                        averagePrice: avgPrice,
                        quantity: qty,
                        salePrice: salePrice
                    ),
                    calculator.calculateTotalAmount(price: avgPrice, quantity: qty),
                    calculator.calculateTotalAmount(price: salePrice, quantity: qty)
                )
                .map { profitResult, purchaseAmount, saleAmount in
                    let profitInfo = ProfitInfoState(
                        totalProfit: profitResult.totalProfit,
                        profitRate: profitResult.profitRate,
                        purchaseAmount: purchaseAmount,
                        saleAmount: saleAmount
                    )
                    
                    return .setProfitInfo(profitInfo)
                }
            }
            
            return .just(.setProfitInfo(ProfitInfoState()))
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .setProfitInfo(info):
            newState.profitInfo = info
        }
        
        return newState
    }
    
}

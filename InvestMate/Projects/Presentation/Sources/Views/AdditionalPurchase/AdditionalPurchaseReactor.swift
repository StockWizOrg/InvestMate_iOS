//
//  AdditionalPurchaseReactor.swift
//  Presentation
//
//  Created by 조호근 on 10/16/24.
//

import Domain

import ReactorKit
import RxSwift

public final class AdditionalPurchaseReactor: Reactor {
    
    public enum Action {
        case updateBoth(holdingPrice: Double?, holdingQuantity: Double?,
                        additionalPrice: Double?, additionalQuantity: Double?)
    }
    
    public enum Mutation {
        case updateValues(holding: StockInfo, additional: StockInfo, final: StockInfo?)
    }
    
    public struct State {
        var holding: StockInfo
        var additional: StockInfo
        var final: StockInfo?
    }
    
    public let initialState: State
    private let calculator: StockCalculatorUseCase
    
    public init(calculator: StockCalculatorUseCase) {
        self.initialState = State(
            holding: StockInfo(),
            additional: StockInfo(),
            final: nil
        )
        self.calculator = calculator
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .updateBoth(holdingPrice, holdingQuantity, additionalPrice, additionalQuantity):
            let holding = StockInfo(
                averagePrice: holdingPrice,
                quantity: holdingQuantity,
                totalPrice: holdingPrice != nil && holdingQuantity != nil ?
                holdingPrice! * holdingQuantity! : nil
            )
            
            let additional = StockInfo(
                averagePrice: additionalPrice,
                quantity: additionalQuantity,
                totalPrice: additionalPrice != nil && additionalQuantity != nil ?
                additionalPrice! * additionalQuantity! : nil
            )
            
            if let hp = holdingPrice, let hq = holdingQuantity,
               let ap = additionalPrice, let aq = additionalQuantity {
                return calculator.calculateFinal(
                    holdingAveragePrice: hp,
                    holdingQuantity: hq,
                    additionalAveragePrice: ap,
                    additionalQuantity: aq
                )
                .map { finalResult in
                        .updateValues(
                            holding: holding,
                            additional: additional,
                            final: StockInfo(
                                averagePrice: finalResult.averagePrice,
                                quantity: finalResult.quantity,
                                totalPrice: finalResult.totalPrice
                            )
                        )
                }
            } else {
                return .just(.updateValues(
                    holding: holding,
                    additional: additional,
                    final: nil
                ))
            }
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .updateValues(holding, additional, final):
            newState.holding = holding
            newState.additional = additional
            newState.final = final
        }
        
        return newState
    }
    
}

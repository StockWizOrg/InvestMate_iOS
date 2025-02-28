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
        // 현재 보유 입력 관련
        case updateHoldingPrice(Double?)
        case updateHoldingQuantity(Double?)
        case updateHoldingTotal(Double?)
        
        // 추가 매수 입력 관련
        case updateAdditionalPrice(Double?)
        case updateAdditionalQuantity(Double?)
        case updateAdditionalTotal(Double?)
        
        case clearInputFields
        case setInitialStock(Stock)
    }
    
    public enum Mutation {
        case updateHolding(StockInfoState)
        case updateAdditional(StockInfoState)
        case updateFinal(StockInfoState?)
        case clearInputs
        case resetAdditional
    }
    
    public struct State {
        var holding: StockInfoState
        var additional: StockInfoState
        var final: StockInfoState?
    }
    
    public let initialState: State
    private let calculator: StockCalculatorUseCase
    
    public init(calculator: StockCalculatorUseCase) {
        self.initialState = State(
            holding: StockInfoState(),
            additional: StockInfoState(),
            final: nil
        )
        self.calculator = calculator
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .updateHoldingPrice(price):
            var holding = currentState.holding
            holding.averagePrice = price
            
            // 평단가가 nil이면 모든 값 초기화
            if price == nil {
                holding.quantity = nil
                holding.totalPrice = nil
                return .concat([
                    .just(.updateHolding(holding)),
                    .just(.resetAdditional)
                ])
            }
            
            // 평단가가 입력되고 수량이 있으면 총액 계산
            if let p = price, let q = holding.quantity {
                return calculator.calculateTotalPrice(averagePrice: p, quantity: q)
                    .flatMap { total -> Observable<Mutation> in
                        holding.totalPrice = total
                        return .concat([
                            .just(.updateHolding(holding)),
                            .just(.resetAdditional)
                        ])
                    }
            }
            // 평단가가 입력되고 총액이 있으면 수량 계산
            else if let p = price, let t = holding.totalPrice {
                return calculator.calculateQuantity(averagePrice: p, totalPrice: t)
                    .flatMap { quantity -> Observable<Mutation> in
                        holding.quantity = quantity
                        return .concat([
                            .just(.updateHolding(holding)),
                            .just(.resetAdditional)
                        ])
                    }
            }
            
            return .concat([
                .just(.updateHolding(holding)),
                .just(.resetAdditional)
            ])
            
        case let .updateHoldingQuantity(quantity):
            var holding = currentState.holding
            holding.quantity = quantity
            
            // 수량이 nil이면 총액도 초기화
            if quantity == nil {
                holding.totalPrice = nil
                return .concat([
                    .just(.updateHolding(holding)),
                    .just(.resetAdditional)
                ])
            }
            
            // 수량이 입력되고 평단가가 있으면 총액 계산
            if let p = holding.averagePrice, let q = quantity {
                return calculator.calculateTotalPrice(averagePrice: p, quantity: q)
                    .flatMap { total -> Observable<Mutation> in
                        holding.totalPrice = total
                        return .concat([
                            .just(.updateHolding(holding)),
                            .just(.resetAdditional)
                        ])
                    }
            }
            
            return .concat([
                .just(.updateHolding(holding)),
                .just(.resetAdditional)
            ])
            
        case let .updateHoldingTotal(total):
            var holding = currentState.holding
            holding.totalPrice = total
            
            // 총액이 nil이면 수량도 초기화
            if total == nil {
                holding.quantity = nil
                return .concat([
                    .just(.updateHolding(holding)),
                    .just(.resetAdditional)
                ])
            }
            
            // 총액이 입력되고 평단가가 있으면 수량 계산
            if let t = total, let p = holding.averagePrice {
                return calculator.calculateQuantity(averagePrice: p, totalPrice: t)
                    .flatMap { quantity -> Observable<Mutation> in
                        holding.quantity = quantity
                        return .concat([
                            .just(.updateHolding(holding)),
                            .just(.resetAdditional)
                        ])
                    }
            }
            
            return .concat([
                .just(.updateHolding(holding)),
                .just(.resetAdditional)
            ])
            
            // 추가 매수 관련 액션들
        case let .updateAdditionalPrice(price):
            var additional = currentState.additional
            additional.averagePrice = price
            
            // 평단가가 nil이면 모든 값 초기화
            if price == nil {
                additional.quantity = nil
                additional.totalPrice = nil
                return calculateFinalIfPossible(additional: additional)
            }
            
            // 평단가가 입력되고 수량이 있으면 총액 계산
            if let p = price, let q = additional.quantity {
                return calculator.calculateTotalPrice(averagePrice: p, quantity: q)
                    .flatMap { total -> Observable<Mutation> in
                        additional.totalPrice = total
                        return self.calculateFinalIfPossible(additional: additional)
                    }
            }
            // 평단가가 입력되고 총액이 있으면 수량 계산
            else if let p = price, let t = additional.totalPrice {
                return calculator.calculateQuantity(averagePrice: p, totalPrice: t)
                    .flatMap { quantity -> Observable<Mutation> in
                        additional.quantity = quantity
                        return self.calculateFinalIfPossible(additional: additional)
                    }
            }
            
            return calculateFinalIfPossible(additional: additional)
            
        case let .updateAdditionalQuantity(quantity):
            var additional = currentState.additional
            additional.quantity = quantity
            
            // 수량이 nil이면 총액 초기화
            if quantity == nil {
                additional.totalPrice = nil
                return calculateFinalIfPossible(additional: additional)
            }
            
            
            // 수량이 입력되고 평단가가 있으면 총액 계산
            if let p = additional.averagePrice, let q = quantity {
                return calculator.calculateTotalPrice(averagePrice: p, quantity: q)
                    .flatMap { total -> Observable<Mutation> in
                        additional.totalPrice = total
                        return self.calculateFinalIfPossible(additional: additional)
                    }
            }
            
            return calculateFinalIfPossible(additional: additional)
            
        case let .updateAdditionalTotal(total):
            var additional = currentState.additional
            additional.totalPrice = total
            
            // 총액이 nil이면 수량 초기화
            if total == nil {
                additional.quantity = nil
                return calculateFinalIfPossible(additional: additional)
            }
            
            // 총액이 입력되고 평단가가 있으면 수량 계산
            if let t = total, let p = additional.averagePrice {
                return calculator.calculateQuantity(averagePrice: p, totalPrice: t)
                    .flatMap { quantity -> Observable<Mutation> in
                        additional.quantity = quantity
                        return self.calculateFinalIfPossible(additional: additional)
                    }
            }
            
            return calculateFinalIfPossible(additional: additional)
            
        case .clearInputFields:
            return .just(.clearInputs)
            
            
        case let .setInitialStock(stock):
            let holding = StockInfoState(
                averagePrice: stock.averagePrice,
                quantity: stock.quantity,
                totalPrice: stock.totalPrice
            )
            
            return .just(.updateHolding(holding))
        }
    }
    
    private func calculateFinalIfPossible(additional: StockInfoState) -> Observable<Mutation> {
        let mutations: [Observable<Mutation>] = [.just(.updateAdditional(additional))]
        
        if let hp = currentState.holding.averagePrice,
           let hq = currentState.holding.quantity,
           let ap = additional.averagePrice,
           let aq = additional.quantity {
            
            return .concat(mutations + [
                calculator.calculateFinal(
                    holdingAveragePrice: hp,
                    holdingQuantity: hq,
                    additionalAveragePrice: ap,
                    additionalQuantity: aq
                )
                .map { finalResult in
                    .updateFinal(StockInfoState(
                        averagePrice: finalResult.averagePrice,
                        quantity: finalResult.quantity,
                        totalPrice: finalResult.totalPrice
                    ))
                }
                    .catch { error in
                        // 에러 처리 로직 추가
                        return .just(.updateFinal(nil))
                    }
            ])
        }
        
        return .concat(mutations + [.just(.updateFinal(nil))])
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case let .updateHolding(holding):
            newState.holding = holding
        case let .updateAdditional(additional):
            newState.additional = additional
        case let .updateFinal(final):
            newState.final = final
        case .resetAdditional:
            newState.additional = StockInfoState()
            newState.final = nil
        case .clearInputs:
            newState.holding = StockInfoState()
            newState.additional = StockInfoState()
            newState.final = nil
            return newState
            
        }
        
        return newState
    }
}

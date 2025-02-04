//
//  StockCalculatorImpl.swift
//  Domain
//
//  Created by 조호근 on 10/15/24.
//

import RxSwift

public struct StockCalculatorImpl: StockCalculatorUseCase {
    
    public init() {}
    
    public func calculateTotalPrice(averagePrice: Double, quantity: Double) -> Observable<Double> {
        return .just(averagePrice * quantity)
    }
    
    public func calculateQuantity(averagePrice: Double, totalPrice: Double) -> Observable<Double> {
        return .just(totalPrice / averagePrice)
    }
    
    public func calculateFinal(
        holdingAveragePrice: Double,
        holdingQuantity: Double,
        additionalAveragePrice: Double,
        additionalQuantity: Double
    ) -> Observable<(averagePrice: Double, quantity: Double, totalPrice: Double)> {
        // 모든 값을 소수점 2자리까지 유지
        let finalQuantity = (holdingQuantity + additionalQuantity).roundedToDecimal()
        
        let holdingTotal = holdingAveragePrice * holdingQuantity
        let additionalTotal = additionalAveragePrice * additionalQuantity
        let finalTotalPrice = (holdingTotal + additionalTotal).roundedToDecimal()
        
        let finalAveragePrice = (finalTotalPrice / finalQuantity).roundedToDecimal()
        
        return .just((finalAveragePrice, finalQuantity, finalTotalPrice))
    }
}

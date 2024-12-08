//
//  ProfitCalculatorImpl.swift
//  Domain
//
//  Created by 조호근 on 12/6/24.
//

import RxSwift

public struct ProfitCalculatorImpl: ProfitCalculatorUseCase {
   
    public init() {}
    
    public func calculateProfit(
        averagePrice: Double,
        quantity: Double,
        salePrice: Double
    ) -> Observable<(totalProfit: Double, profitRate: Double)> {
        let purchaseAmount = averagePrice * quantity
        let saleAmount = salePrice * quantity
        
        let totalProfit = (saleAmount - purchaseAmount).rounded(toPlaces: 2)
        let profitRate = ((salePrice - averagePrice) / averagePrice * 100).rounded(toPlaces: 2)
        
        return .just((totalProfit, profitRate))
    }
    
    public func calculateTotalAmount(
        price: Double,
        quantity: Double
    ) -> Observable<Double> {
        let totalAmount = (price * quantity).rounded(toPlaces: 2)
        
        return .just(totalAmount)
    }
    
    
}

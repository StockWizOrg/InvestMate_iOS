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
        
        let totalProfit = (saleAmount - purchaseAmount).roundedToDecimal()
        let profitRate = ((salePrice - averagePrice) / averagePrice * 100).roundedToDecimal()
        
        return .just((totalProfit, profitRate))
    }
    
    public func calculateTotalAmount(
        price: Double,
        quantity: Double
    ) -> Observable<Double> {
        let totalAmount = (price * quantity).roundedToDecimal()
        
        return .just(totalAmount)
    }
    
    
}

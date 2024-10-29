//
//  StockCalculatorUseCase.swift
//  Domain
//
//  Created by 조호근 on 10/15/24.
//

import RxSwift

public protocol StockCalculatorUseCase {
    func calculateTotalPrice(
        averagePrice: Double,
        quantity: Double
    ) -> Observable<Double>
    
    func calculateQuantity(
        averagePrice: Double,
        totalPrice: Double
    ) -> Observable<Double>
    
    
    func calculateFinal(
        holdingAveragePrice: Double,
        holdingQuantity: Double,
        additionalAveragePrice: Double,
        additionalQuantity: Double
    ) -> Observable<(averagePrice: Double, quantity: Double, totalPrice: Double)>
}

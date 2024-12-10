//
//  ProfitCalculatorUsecase.swift
//  Domain
//
//  Created by 조호근 on 12/6/24.
//

import RxSwift

public protocol ProfitCalculatorUseCase {
    
    func calculateProfit(
        averagePrice: Double,
        quantity: Double,
        salePrice: Double
    ) -> Observable<(totalProfit: Double, profitRate: Double)>
    
    func calculateTotalAmount(
        price: Double,
        quantity: Double
    ) -> Observable<Double>
    
}



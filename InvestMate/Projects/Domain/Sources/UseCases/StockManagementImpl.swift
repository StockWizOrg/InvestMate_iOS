//
//  StockManagementImpl.swift
//  Domain
//
//  Created by 조호근 on 12/13/24.
//

import Foundation
import RxSwift

public final class StockManagementImpl: StockManagementUseCase {
    
    private let repository: StockRepository
    private let calculator: StockCalculatorUseCase
    
    public init(repository: StockRepository, calculator: StockCalculatorUseCase) {
        self.repository = repository
        self.calculator = calculator
    }
    
    public func getAllStocks() -> Observable<[Stock]> {
        return repository.getAllStocks()
    }
    
    public func addStock(
        name: String,
        averagePrice: Double,
        quantity: Double
    ) -> Observable<Void> {
        return calculator.calculateTotalPrice(averagePrice: averagePrice, quantity: quantity)
            .map { totalPrice in
                Stock(
                    name: name,
                    averagePrice: averagePrice,
                    quantity: quantity,
                    totalPrice: totalPrice
                )
            }
            .flatMap { stock in
                self.repository.addStock(stock)
            }
    }
    
    public func updateStock(
        id: UUID,
        name: String,
        averagePrice: Double,
        quantity: Double
    ) -> Observable<Void> {
        return calculator.calculateTotalPrice(averagePrice: averagePrice, quantity: quantity)
            .map { totalPrice in
                Stock(
                    id: id,
                    name: name,
                    averagePrice: averagePrice,
                    quantity: quantity,
                    totalPrice: totalPrice
                )
            }
            .flatMap { stock in
                self.repository.updateStock(stock)
            }
    }
    
    public func deleteStock(id: UUID) -> Observable<Void> {
        return repository.deleteStock(id)
    }
    
}

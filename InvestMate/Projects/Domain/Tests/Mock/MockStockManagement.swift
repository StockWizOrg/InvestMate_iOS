//
//  MockStockManagement.swift
//  Domain
//
//  Created by 조호근 on 12/24/24.
//

import Foundation

import RxSwift

public final class MockStockManagement: StockManagementUseCase {
    
    public init() {}
    
    public func getAllStocks() -> Observable<[Stock]> {
        return .just([])
    }
    
    public func addStock(name: String, averagePrice: Double, quantity: Double) -> Observable<Void> {
        return .just(())
    }
    
    public func updateStock(id: UUID, name: String, averagePrice: Double, quantity: Double) -> Observable<Void> {
        return .just(())
    }
    
    public func deleteStock(id: UUID) -> Observable<Void> {
        return .just(())
    }
}

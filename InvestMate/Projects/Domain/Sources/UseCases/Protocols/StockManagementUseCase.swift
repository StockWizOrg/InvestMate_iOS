//
//  StockManagementUseCase.swift
//  StockTests
//
//  Created by 조호근 on 12/13/24.
//

import Foundation
import RxSwift

public protocol StockManagementUseCase {
    
    func getAllStocks() -> Observable<[Stock]>
    func addStock(name: String, averagePrice: Double, quantity: Double) -> Observable<Void>
    func updateStock(id: UUID, name: String, averagePrice: Double, quantity: Double) -> Observable<Void>
    func deleteStock(id: UUID) -> Observable<Void>
    
}

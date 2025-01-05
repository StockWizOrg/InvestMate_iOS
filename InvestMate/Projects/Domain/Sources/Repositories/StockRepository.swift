//
//  StockRepository.swift
//  StockTests
//
//  Created by 조호근 on 12/13/24.
//

import Foundation
import RxSwift

public protocol StockRepository {
    
    func getAllStocks() -> Observable<[Stock]>
    func addStock(_ stock: Stock) -> Observable<Void>
    func updateStock(_ stock: Stock) -> Observable<Void>
    func deleteStock(_ id: UUID) -> Observable<Void>
    
}

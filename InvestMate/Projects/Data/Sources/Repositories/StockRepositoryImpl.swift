//
//  StockRepositoryImpl.swift
//  DataManifests
//
//  Created by 조호근 on 10/1/24.
//

import Domain

public class StockRepositoryImpl: StockRepository {
    public init() {}

    public func fetchStocks() -> [Stock] {
        return [
            Stock(id: 1, name: "Apple", price: 150.0),
            Stock(id: 2, name: "Tesla", price: 700.0),
            Stock(id: 3, name: "Google", price: 2800.0)
        ]
    }
}

//
//  StockViewModel.swift
//  Presentation
//
//  Created by 조호근 on 10/1/24.
//

import Domain

public class StockViewModel {
    private let stockUseCase: StockUseCase
    
    public init(stockUseCase: StockUseCase) {
        self.stockUseCase = stockUseCase
    }
    
    public func getStockNames() -> [String] {
        return stockUseCase.getStocks().map { $0.name }
    }
}

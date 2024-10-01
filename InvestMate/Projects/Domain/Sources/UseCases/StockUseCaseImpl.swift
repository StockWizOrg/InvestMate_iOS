//
//  StockUseCaseImpl.swift
//  DomianManifests
//
//  Created by 조호근 on 10/1/24.
//

import Foundation

public class StockUseCaseImpl: StockUseCase {
    private let repository: StockRepository
    
    public init(repository: StockRepository) {
        self.repository = repository
    }
    
    public func getStocks() -> [Stock] {
        return repository.fetchStocks()
    }
}

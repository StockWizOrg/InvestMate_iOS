//
//  StockRepository.swift
//  DomianManifests
//
//  Created by 조호근 on 10/1/24.
//

import Foundation

public protocol StockRepository {
    func fetchStocks() -> [Stock]
}

//
//  StockInfo.swift
//  Domain
//
//  Created by 조호근 on 10/16/24.
//

import Foundation

public struct StockInfo: Equatable {
    
    public let averagePrice: Double?
    public let quantity: Double?
    public let totalPrice: Double?
    
    public init(averagePrice: Double? = nil, quantity: Double? = nil, totalPrice: Double? = nil) {
        self.averagePrice = averagePrice
        self.quantity = quantity
        self.totalPrice = totalPrice
    }
    
}

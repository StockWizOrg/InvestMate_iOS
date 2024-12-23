//
//  Stock.swift
//  StockTests
//
//  Created by 조호근 on 12/13/24.
//

import Foundation

public struct Stock: Equatable, Identifiable {
    
    public let id: UUID
    public let name: String
    public let averagePrice: Double
    public let quantity: Double
    public let totalPrice: Double
    
    public init(
        id: UUID = UUID(),
        name: String,
        averagePrice: Double,
        quantity: Double,
        totalPrice: Double
    ) {
        self.id = id
        self.name = name
        self.averagePrice = averagePrice
        self.quantity = quantity
        self.totalPrice = totalPrice
    }
    
    public static let sample = Stock(
        id: UUID(),
        name: "Apple",
        averagePrice: 145.5,
        quantity: 10.0,
        totalPrice: 1455.0
    )
}

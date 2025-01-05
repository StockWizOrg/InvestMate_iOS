//
//  StockModel.swift
//  Data
//
//  Created by 조호근 on 12/13/24.
//
import Foundation
import SwiftData

@Model
final class StockModel {
    
    @Attribute(.unique) var id: UUID
    var name: String
    var averagePrice: Double
    var quantity: Double
    var totalPrice: Double
    
    init(
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
    
}

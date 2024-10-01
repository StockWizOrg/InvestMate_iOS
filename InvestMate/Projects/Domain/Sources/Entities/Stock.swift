//
//  Stock.swift
//  DomianManifests
//
//  Created by 조호근 on 10/1/24.
//

import Foundation

public struct Stock {
    public let id: Int
    public let name: String
    public let price: Double
    
    public init(id: Int, name: String, price: Double) {
        self.id = id
        self.name = name
        self.price = price
    }
}

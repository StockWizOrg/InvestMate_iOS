//
//  ProfitInfo.swift
//  Domain
//
//  Created by 조호근 on 12/6/24.
//

import Foundation

public struct ProfitInfo: Equatable {
    
    public let totalProfit: Double?
    public let profitRate: Double?
    public let purchaseAmount: Double?
    public let saleAmount: Double?
    
    public init(
        totalProfit: Double? = nil,
        profitRate: Double? = nil,
        purchaseAmount: Double? = nil,
        saleAmount: Double? = nil
    ) {
        self.totalProfit = totalProfit
        self.profitRate = profitRate
        self.purchaseAmount = purchaseAmount
        self.saleAmount = saleAmount
    }
    
}

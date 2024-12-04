//
//  String+.swift
//  Presentation
//
//  Created by 조호근 on 10/28/24.
//

import Foundation

extension String {
    
    func toDouble() -> Double? {
        let cleanText = self.replacingOccurrences(of: ",", with: "")
        
        if cleanText.isEmpty { return nil }
        
        return Decimal(string: cleanText).flatMap {
            NSDecimalNumber(decimal: $0).doubleValue
        }
    }
    
}

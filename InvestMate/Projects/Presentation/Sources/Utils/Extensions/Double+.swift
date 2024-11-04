//
//  Double+.swift
//  Presentation
//
//  Created by 조호근 on 10/28/24.
//

import Foundation

extension Double {
    
    func toFormattedString() -> String {
        if self.truncatingRemainder(dividingBy: 1) == 0 {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 0
            return formatter.string(from: NSNumber(value: self)) ?? String(Int(self))
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: self)) ?? String(self)
    }
    
}

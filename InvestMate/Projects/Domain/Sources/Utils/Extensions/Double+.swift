//
//  Double+.swift
//  Domain
//
//  Created by 조호근 on 10/28/24.
//

import Foundation

public extension Double {
    
    private static var decimalPlaces: Int {
        return UserDefaults.standard.integer(forKey: "DecimalPlaces").nonZero ?? 1
    }
    
    static func updateDecimalPlaces(_ places: Int) {
        UserDefaults.standard.set(places, forKey: "DecimalPlaces")
        print("✅ 소수점 설정 변경: \(places) 자리")
    }
    
    func roundedToDecimal() -> Double {
        let multiplier = pow(10.0, Double(Self.decimalPlaces))
        return (self * multiplier).rounded() / multiplier
    }
    
}

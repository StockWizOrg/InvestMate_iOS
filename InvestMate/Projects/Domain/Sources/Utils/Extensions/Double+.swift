//
//  Double+.swift
//  Domain
//
//  Created by 조호근 on 10/28/24.
//

import Foundation

extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let multiplier = pow(10.0, Double(places))
        return (self * multiplier).rounded() / multiplier
    }
}

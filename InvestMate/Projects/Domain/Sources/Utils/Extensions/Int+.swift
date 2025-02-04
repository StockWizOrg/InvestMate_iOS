//
//  Int+.swift
//  Domain
//
//  Created by 조호근 on 2/1/25.
//

import Foundation

public extension Int {
    
    var nonZero: Int? {
        return self == 0 ? nil : self
    }
    
}

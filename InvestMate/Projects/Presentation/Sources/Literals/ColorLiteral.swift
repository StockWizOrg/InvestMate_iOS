//
//  ColorLiteral.swift
//  Presentation
//
//  Created by 조호근 on 2/27/25.
//

import SwiftUI

public enum Black: String {
    case chineseBlack = "0F0F27"
}

public enum Pink: String {
    case pink = "FF2C6B"
}

public extension UIColor {
    
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let hexCode: Int = Int(hex, radix: 16) ?? 0
        let red = CGFloat((hexCode >> 16) & 0xff) / 255.0
        let green = CGFloat((hexCode >> 8) & 0xff) / 255.0
        let blue = CGFloat((hexCode >> 0) & 0xff) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
        
    static func customBlack(_ color: Black) -> UIColor {
        return UIColor(hex: color.rawValue)
    }
    
    static func customPink(_ color: Pink) -> UIColor {
        return UIColor(hex: color.rawValue)
    }
    
}

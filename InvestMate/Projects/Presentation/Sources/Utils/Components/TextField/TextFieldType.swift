//
//  TextFieldType.swift
//  Presentation
//
//  Created by 조호근 on 2/6/25.
//

import UIKit

public enum TextFieldType {
    
    case name
    case numeric
    
    var keyboardType: UIKeyboardType {
        switch self {
        case .name:
            return .default
        case .numeric:
            return .decimalPad
        }
    }
    
    var needsValidation: Bool {
        switch self {
        case .name:
            return false
        case .numeric:
            return true
        }
    }
    
    func validateNumeric(currentText: String, replacementString string: String) -> Bool {
        guard needsValidation else { return true }
        
        if currentText.isEmpty || string.isEmpty {
            return true
        }
        
        let cleanText = currentText.replacingOccurrences(of: ",", with: "")
        
        if string == "." {
            let hasDot = cleanText.contains(".")
            return !hasDot && cleanText != "."
        }
        
        if cleanText.contains(".") {
            let parts = cleanText.components(separatedBy: ".")
            let maxDecimalPlaces = UserDefaults.standard.integer(forKey: "DecimalPlaces").nonZero ?? 1
            if parts.count > 1 && parts[1].count > maxDecimalPlaces {
                return false
            }
        }
        
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
}

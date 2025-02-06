//
//  TextFieldNavigatable.swift
//  Presentation
//
//  Created by 조호근 on 2/6/25.
//

import UIKit

protocol TextFieldNavigatable {
    
    var textFields: [LabeledTextFieldView] { get }
    
}

extension TextFieldNavigatable {
    
    func setupTextFieldNavigation() {
        for (index, field) in textFields.enumerated() {
            let previous = index > 0 ? textFields[index - 1] : nil
            let next = index < textFields.count - 1 ? textFields[index + 1] : nil
            
        }
    }
}

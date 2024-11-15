//
//  UITextField+.swift
//  Presentation
//
//  Created by 조호근 on 11/15/24.
//

import UIKit

extension UITextField {
    
    func configureNumericInputField(placeholder: String,
                                  fontSize: CGFloat,
                                  weight: UIFont.Weight,
                                  padding: CGFloat) {
        self.font = .systemFont(ofSize: fontSize, weight: weight)
        self.borderStyle = .roundedRect
        self.keyboardType = .numberPad
        self.placeholder = placeholder
        self.tintColor = .label
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        self.spellCheckingType = .no
        
        addPadding(padding: padding)
        configureAppearance()
    }
    
    private func addPadding(padding: CGFloat) {
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.height))
        self.leftView = leftPaddingView
        self.leftViewMode = .always
        
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.height))
        self.rightView = rightPaddingView
        self.rightViewMode = .always
    }
    
    private func configureAppearance() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.systemGray6.cgColor
    }
    
}

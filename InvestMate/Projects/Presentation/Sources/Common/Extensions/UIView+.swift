//
//  UIView+.swift
//  Presentation
//
//  Created by 조호근 on 10/9/24.
//

import UIKit

extension UIView {
    
    func addSubviews(_ views: UIView...) {
        views.forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func configureNumericInputField(placeholder: String,
                                    fontSize: CGFloat,
                                    weight: UIFont.Weight,
                                    padding: CGFloat) {
        guard let textField = self as? UITextField else { return }
        
        textField.font = .systemFont(ofSize: fontSize, weight: weight)
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.placeholder = placeholder
        textField.tintColor = .label
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.spellCheckingType = .no
        
        
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.height))
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
        
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.height))
        textField.rightView = rightPaddingView
        textField.rightViewMode = .always
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.systemGray6.cgColor
    }
    
    func configureDivider(height: CGFloat = 1, color: UIColor = .systemGray4) {
        self.backgroundColor = color
        
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: height)
        ])
    }
}

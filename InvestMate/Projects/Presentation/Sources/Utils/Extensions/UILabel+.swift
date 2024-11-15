//
//  UILabel+.swift
//  Presentation
//
//  Created by 조호근 on 10/9/24.
//

import UIKit

extension UILabel {
    
    func configureTitleLabel(title: String,
                        ofSize: CGFloat,
                        weight: UIFont.Weight,
                        indent: CGFloat = 0) {
        self.numberOfLines = 0
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = indent
        paragraphStyle.alignment = .left
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: ofSize, weight: weight),
            .foregroundColor: UIColor.label,
            .paragraphStyle: paragraphStyle
        ]
        
        self.attributedText = NSAttributedString(string: title, attributes: attributes)
    }
    
    func configureNumericLabel() {
        self.font = .systemFont(ofSize: 16, weight: .bold)
        self.backgroundColor = .white
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
    }

}

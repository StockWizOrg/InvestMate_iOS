//
//  UILabel+.swift
//  Presentation
//
//  Created by 조호근 on 10/9/24.
//

import UIKit

extension UILabel {
    
    func configureLabel(title: String,
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
}

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
    
    func configureDivider(height: CGFloat = 1, color: UIColor = .systemGray4) {
        self.backgroundColor = color
        
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: height)
        ])
    }
    
}

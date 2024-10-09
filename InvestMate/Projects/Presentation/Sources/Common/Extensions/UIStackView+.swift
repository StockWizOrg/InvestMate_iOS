//
//  UIStackView+.swift
//  Presentation
//
//  Created by 조호근 on 10/9/24.
//

import UIKit

extension UIStackView {
    
    func addArrangedSubviews(_ subviews: UIView...) {
        subviews.forEach{ addArrangedSubview($0) }
    }
    
    func configureStackView(axis: NSLayoutConstraint.Axis = .vertical,
                            isMainStack: Bool = false) {
        self.axis = axis
        self.alignment = .fill
        self.distribution = .fillProportionally
        
        if isMainStack {
            self.spacing = 8
        } else {
            self.spacing = 4
        }
    }
}

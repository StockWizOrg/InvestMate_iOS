//
//  UIStackView+.swift
//  Presentation
//
//  Created by 조호근 on 10/9/24.
//

import UIKit

extension UIStackView {
    
    func addArrangedSubviews(_ subviews: UIView...) {
        subviews.forEach{
            addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func configureStackView(axis: NSLayoutConstraint.Axis = .vertical,
                            alignment: UIStackView.Alignment = .fill ,
                            distribution: UIStackView.Distribution = .fillProportionally,
                            spacing: CGFloat = 4) {
        
        self.axis = axis
        self.alignment = alignment
        self.distribution = distribution
        self.spacing = spacing
    }
    
}

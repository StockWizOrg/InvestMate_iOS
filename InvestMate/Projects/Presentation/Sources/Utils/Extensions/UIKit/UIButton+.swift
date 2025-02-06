//
//  UIButton+.swift
//  Presentation
//
//  Created by 조호근 on 2/5/25.
//

import UIKit

extension UIButton {
    
    func configureMoreMenuButton(title: String) {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .systemGray
        
        let attributes = AttributeContainer([
            .font: UIFont.systemFont(ofSize: 14, weight: .regular)
        ])
        
        config.attributedTitle = AttributedString(title, attributes: attributes)
        config.image = UIImage(systemName: "chevron.right")?.withConfiguration(
            UIImage.SymbolConfiguration(pointSize: 10, weight: .semibold)
        )
        config.imagePadding = 12
        config.imagePlacement = .trailing
        
        self.configuration = config
    }
    
}

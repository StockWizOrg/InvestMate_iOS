//
//  LabeledTextFieldView.swift
//  Presentation
//
//  Created by 조호근 on 10/9/24.
//

import UIKit

class LabeledTextFieldView: UIView {
    
    private let titleLabel = UILabel()
    private let textField = UITextField()
    private let stackView = UIStackView()
    
    init(title: String, placeholder: String) {
        super.init(frame: .zero)
        
        setStyle(title: title, placeholder: placeholder)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    private func setStyle(title: String, placeholder: String) {
        titleLabel.configureLabel(title: title, ofSize: 14, weight: .semibold, indent: 8)
        
        textField.configureNumericInputField(placeholder: placeholder, fontSize: 14, weight: .bold, padding: 10)
        
        stackView.addArrangedSubviews(titleLabel, textField)
        stackView.configureStackView()
    }
    
    private func setUI() {
        self.addSubviews(stackView)
    }
    
    private func setLayout() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

#if DEBUG
import SwiftUI

#Preview {
    LabeledTextFieldView(title: "Title", placeholder: "텍스트 필드").toPreview()
        .frame(width: 150, height: 80)
}
#endif

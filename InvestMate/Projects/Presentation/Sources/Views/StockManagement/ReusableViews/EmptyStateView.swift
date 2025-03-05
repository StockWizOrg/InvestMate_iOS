//
//  EmptyStateView.swift
//  Presentation
//
//  Created by 조호근 on 12/23/24.
//

import UIKit

import RxSwift
import RxCocoa

class EmptyStateView: UIView {
    
    var addButtonTap: ControlEvent<Void> {
        return addButton.rx.tap
    }

    private let messageLabel = UILabel()
    private let addButton = UIButton()
    private let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setStyle()
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setStyle() {
        backgroundColor = .systemGray6
        
        messageLabel.configureTitleLabel(
            title: String(localized: "No Registered Stocks", bundle: .module),
            ofSize: 16,
            weight: .medium
        )
        messageLabel.textColor = .darkGray
        messageLabel.textAlignment = .center
        
        stackView.configureStackView(axis: .vertical, spacing: 20)
        
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.baseForegroundColor = .white
        config.baseBackgroundColor = UIColor.customBlack(.chineseBlack)
        
        let attributes =  AttributeContainer([
            .font: UIFont.systemFont(ofSize: 16, weight: .semibold)
        ])
        
        config.attributedTitle = AttributedString(String(localized: "Register New Stock", bundle: .module), attributes: attributes)
        addButton.configuration = config
    }
    
    private func setUI() {
        stackView.addArrangedSubviews(messageLabel, addButton)
        addSubviews(stackView)
    }
    
    private func setLayout() {
        NSLayoutConstraint.activate([
            addButton.heightAnchor.constraint(equalToConstant: 50),
            
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

}

#if DEBUG
import SwiftUI

#Preview {
    EmptyStateView().toPreview()
}

#endif

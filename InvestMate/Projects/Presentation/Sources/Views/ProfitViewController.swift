//
//  ProfitViewController.swift
//  Presentation
//
//  Created by 조호근 on 10/28/24.
//

import UIKit

public class ProfitViewController: UIViewController {
    
    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let purchasePriceTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "매수 가격"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private let currentPriceTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "현재 가격"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private let quantityTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "수량"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.text = "수익률: 0%"
        label.textAlignment = .center
        return label
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        title = "수익 계산"
        view.backgroundColor = .systemBackground
        
        view.addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(purchasePriceTextField)
        mainStackView.addArrangedSubview(currentPriceTextField)
        mainStackView.addArrangedSubview(quantityTextField)
        mainStackView.addArrangedSubview(resultLabel)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}

#if DEBUG
import SwiftUI

#Preview {
    ProfitViewController().toPreview()
}
#endif

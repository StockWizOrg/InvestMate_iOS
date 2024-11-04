//
//  LabeledTextFieldView.swift
//  Presentation
//
//  Created by 조호근 on 10/9/24.
//

import UIKit

import RxSwift
import RxCocoa

class LabeledTextFieldView: UIView {
    
    private let titleLabel = UILabel()
    private let textField = UITextField()
    private let stackView = UIStackView()
    
    private let disposeBag = DisposeBag()
    private let formattedTextRelay = BehaviorRelay<String?>(value: nil)
    
    var textObservable: Observable<String?> {
        return formattedTextRelay.asObservable()
    }
    
    init(title: String, placeholder: String) {
        super.init(frame: .zero)
        
        setStyle(title: title, placeholder: placeholder)
        setUI()
        setLayout()
        setupBindings()
        setDelegate()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setStyle(title: String, placeholder: String) {
        titleLabel.configureLabel(title: title, ofSize: 14, weight: .semibold, indent: 8)
        
        textField.configureNumericInputField(placeholder: placeholder, fontSize: 14, weight: .bold, padding: 10)
        textField.keyboardType = .decimalPad
        
        stackView.addArrangedSubviews(titleLabel, textField)
        stackView.configureStackView()
    }
    
    private func setUI() {
        self.addSubviews(stackView)
    }
    
    private func setLayout() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setDelegate() {
        self.textField.delegate = self
    }
    
}

extension LabeledTextFieldView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""
        let text = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        
        if text.isEmpty || string.isEmpty {
            return true
        }
        
        let cleanText = text.replacingOccurrences(of: ",", with: "")
        
        if string == "." {
            let hasDot = currentText.replacingOccurrences(of: ",", with: "").contains(".")
            
            if hasDot {
                return false
            }
            
            if cleanText == "." {
                return false
            }
            return true
        }
        
        if cleanText.contains(".") {
            let parts = cleanText.components(separatedBy: ".")
            if parts.count > 1 && parts[1].count > 2 {
                return false
            }
        }

        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
}

extension LabeledTextFieldView {
    
    func getText() -> String {
        return textField.text ?? ""
    }
    
    func setText(_ text: String?) {
        textField.text = formatText(text)
    }
    
    func setEditable(_ editable: Bool) {
        textField.isEnabled = editable
        textField.alpha = editable ? 1.0 : 0.6
    }
    
    private func setupBindings() {
        textField.rx.text
            .distinctUntilChanged()
            .compactMap { [weak self] in
                guard let self = self else { return nil }
                return self.formatText($0)
            }
            .bind(to: formattedTextRelay)
            .disposed(by: disposeBag)
        
        formattedTextRelay
            .bind(to: textField.rx.text)
            .disposed(by: disposeBag)
        
    }
    
    private func validateAndFormatNumber(_ text: String, replacementString string: String? = nil) -> Bool {
        let cleanText = text.replacingOccurrences(of: ",", with: "")
        
        // 빈 텍스트 처리
        if text.isEmpty {
            return true
        }
        
        // 소수점 검증
        if let input = string, input == "." {
            let hasDot = cleanText.contains(".")
            return !hasDot && cleanText != "."
        }
        
        // 소수점 자릿수 검증
        if cleanText.contains(".") {
            let parts = cleanText.components(separatedBy: ".")
            if parts.count > 1 && parts[1].count > 2 {
                return false
            }
        }
        
        return true
    }
    
    private func formatText(_ text: String?) -> String? {
        guard let text = text, !text.isEmpty else { return "" }
        let cleanText = text.replacingOccurrences(of: ",", with: "")
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        
        // 소수점이 포함된 경우
        if cleanText.contains(".") {
            let parts = cleanText.components(separatedBy: ".")
            guard let integerPart = parts.first else { return text }
            let decimalPart = parts.count > 1 ? parts[1] : ""
            
            let formattedInteger = formatter.string(from: NSNumber(value: Double(integerPart) ?? 0)) ?? integerPart
            
            if text.hasSuffix(".") {
                return "\(formattedInteger)."
            }
            if !decimalPart.isEmpty {
                return "\(formattedInteger).\(decimalPart)"
            }
            
            return formattedInteger
        }
        
        // 정수만 입력된 경우
        if let number = Double(cleanText) {
            return formatter.string(from: NSNumber(value: number)) ?? ""
        }
        
        return text
    }
    
}

#if DEBUG
import SwiftUI

#Preview {
    LabeledTextFieldView(title: "Title", placeholder: "텍스트 필드").toPreview()
        .frame(width: 150, height: 60)
}
#endif

//
//  LabeledTextFieldView.swift
//  Presentation
//
//  Created by 조호근 on 10/9/24.
//

import UIKit

import RxSwift
import RxRelay

class LabeledTextFieldView: UIView {
    
    private let titleLabel = UILabel()
    private let textField = UITextField()
    private let stackView = UIStackView()
    private let type: TextFieldType
    
    private let disposeBag = DisposeBag()
    private let formattedTextRelay = BehaviorRelay<String?>(value: nil)
    
    var textObservable: Observable<String?> {
        return formattedTextRelay.asObservable()
    }
    
    private var previousField: UITextField?
    private var nextField: UITextField?
    
    init(title: String, ofSize: Int = 14, placeholder: String, type: TextFieldType = .numeric) {
        self.type = type
        super.init(frame: .zero)
        
        setStyle(title: title, ofSize: ofSize, placeholder: placeholder)
        setUI()
        setLayout()
        setupBindings()
        setDelegate()
    }
    
    required init?(coder: NSCoder) {
        self.type = .numeric
        super.init(coder: coder)
    }
    
    private func setStyle(title: String, ofSize: Int, placeholder: String) {
        
        if ofSize == 14 {
            titleLabel.configureTitleLabel(title: title, ofSize: 14, weight: .semibold, indent: 8)
        } else if ofSize == 20 {
            titleLabel.configureTitleLabel(title: title, ofSize: 20, weight: .bold, indent: 8)
        }
        
        setupKeyboardToolbar()
        textField.configureNumericInputField(placeholder: placeholder, fontSize: 14, weight: .bold, padding: 10)
        textField.keyboardType = type.keyboardType
        textField.addTarget(self, action: #selector(textFieldDidBeginEditing), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(textFieldDidEndEditing), for: .editingDidEnd)
        
        stackView.addArrangedSubviews(titleLabel, textField)
        stackView.configureStackView()
    }
    
    private func setUI() {
        self.addSubviews(stackView)
    }
    
    private func setLayout() {
        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: 44),
            
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
        return type.validateNumeric(currentText: currentText, replacementString: string)
    }
    
}

extension LabeledTextFieldView {
    
    func getText() -> String {
        return textField.text ?? ""
    }
    
    func setText(_ text: String?) {
        let formattedText = type == .numeric ? formatText(text) : text
        textField.text = formattedText
    }
    
    func setEditable(_ editable: Bool) {
        textField.isEnabled = editable
        textField.alpha = editable ? 1.0 : 0.6
    }
    
    private func setupBindings() {
        if type == .name {
            textField.rx.text
                .bind(to: formattedTextRelay)
                .disposed(by: disposeBag)
        } else {
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

extension LabeledTextFieldView {
    
    private func setupKeyboardToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let previousButton = UIBarButtonItem(
            title: "이전",
            style: .plain,
            target: self,
            action: #selector(moveToPreviousField)
        )
        
        let nextButton = UIBarButtonItem(
            title: "다음",
            style: .plain,
            target: self,
            action: #selector(moveToNextField)
        )
        
        let flexSpace = UIBarButtonItem(systemItem: .flexibleSpace)
        
        let doneButton = UIBarButtonItem(
            title: "완료",
            style: .done,
            target: self,
            action: #selector(dismissKeyboard)
        )
        
        toolbar.items = [previousButton, nextButton, flexSpace, doneButton]
        textField.inputAccessoryView = toolbar
        
    }
    
    func setNavigationFields(previous: LabeledTextFieldView?, next: LabeledTextFieldView?) {
        self.previousField = previous?.textField
        self.nextField = next?.textField
    }
    
}

@objc
private extension LabeledTextFieldView {
    
    private func textFieldDidBeginEditing() {
        textField.layer.borderColor = UIColor.tintColor.cgColor
        textField.layer.borderWidth = 1
    }
    
    private func textFieldDidEndEditing() {
        textField.layer.borderColor = UIColor.systemGray6.cgColor
    }
    
    private func moveToPreviousField() {
        previousField?.becomeFirstResponder()
    }
    
    private func moveToNextField() {
        nextField?.becomeFirstResponder()
    }
    
    private func dismissKeyboard() {
        textField.resignFirstResponder()
    }
    
}

#if DEBUG
import SwiftUI

#Preview {
    LabeledTextFieldView(title: "Title", placeholder: "텍스트 필드").toPreview()
        .frame(width: 150, height: 60)
}
#endif

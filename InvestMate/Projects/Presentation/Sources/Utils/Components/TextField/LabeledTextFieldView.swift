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
            titleLabel.configureTitleLabel(title: title, ofSize: 14, weight: .semibold)
        } else if ofSize == 20 {
            titleLabel.configureTitleLabel(title: title, ofSize: 20, weight: .bold)
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
    
    private func formatText(_ text: String?) -> String? {
        guard let text = text, !text.isEmpty else { return "" }
        let cleanText = text.replacingOccurrences(of: ",", with: "")
                
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = UserDefaults.standard.integer(forKey: "DecimalPlaces").nonZero ?? 1

        if let number = Double(cleanText) {
            return formatter.string(from: NSNumber(value: number)) ?? ""
        }

        return text
    }
    
}

extension LabeledTextFieldView {
    
    private func setupKeyboardToolbar() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        
        let previousButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(moveToPreviousField)
        )
        
        let spaceBetweenButtons = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spaceBetweenButtons.width = 16
        
        let nextButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.right"),
            style: .plain,
            target: self,
            action: #selector(moveToNextField)
        )
        
        let flexSpace = UIBarButtonItem(systemItem: .flexibleSpace)
        
        let doneButton = UIBarButtonItem(
            title: String(localized: "Done", bundle: .module),
            style: .done,
            target: self,
            action: #selector(dismissKeyboard)
        )
        
        [previousButton, nextButton, doneButton].forEach {
            $0.tintColor = UIColor.customBlack(.chineseBlack)
        }
        
        toolbar.items = [previousButton, spaceBetweenButtons, nextButton, flexSpace, doneButton]
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
        textField.layer.borderColor = UIColor.customBlack(.chineseBlack).cgColor
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

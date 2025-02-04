//
//  MoreMenuViewController.swift
//  Presentation
//
//  Created by 조호근 on 1/31/25.
//

import UIKit
import Domain

class MoreMenuViewController: UIViewController {
    
    private let versionTitleLabel = UILabel()
    private let versionValueLabel = UILabel()
    private let versionDividerView = UIView()
    private let settingsTitleLabel = UILabel()
    private let infoTitleLabel = UILabel()
    private let decimalDisplayButton = UIButton()
    private let settingsDividerView = UIView()
    
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setUI()
        setLayout()
        configureConfirmButton()
    }
    

    private func setStyle() {
        self.title = "더보기"
        self.view.backgroundColor = .systemGray6
        
        versionTitleLabel.configureTitleLabel(
            title: "앱 버전 정보",
            ofSize: 16,
            weight: .bold
        )
        
        versionValueLabel.configureTitleLabel(
            title: "\(appVersion) (\(buildNumber))",
            ofSize: 14,
            weight: .regular
        )
        versionValueLabel.textColor = .systemGray

        settingsTitleLabel.configureTitleLabel(
            title: "설정",
            ofSize: 16,
            weight: .bold
        )
        
        infoTitleLabel.configureTitleLabel(
            title: "정보 표시 설정",
            ofSize: 14,
            weight: .regular
        )
        infoTitleLabel.textColor = .systemGray
        
        [versionDividerView, settingsDividerView].forEach {
            $0.configureDivider()
        }
        
    }
    
    private func setUI() {
        self.view.addSubviews(
            versionTitleLabel,
            versionValueLabel,
            versionDividerView,
            settingsTitleLabel,
            infoTitleLabel,
            decimalDisplayButton,
            settingsDividerView
        )
    }
    
    private func setLayout() {
        let safeArea = view.safeAreaLayoutGuide
        let leadingAnchor = view.leadingAnchor
        let trailingAnchor = view.trailingAnchor
        
        NSLayoutConstraint.activate([
            versionTitleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 32),
            versionTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            versionValueLabel.topAnchor.constraint(equalTo: versionTitleLabel.bottomAnchor, constant: 28),
            versionValueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            versionDividerView.topAnchor.constraint(equalTo: versionValueLabel.bottomAnchor, constant: 28),
            versionDividerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            versionDividerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            settingsTitleLabel.topAnchor.constraint(equalTo: versionDividerView.bottomAnchor, constant: 28),
            settingsTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            infoTitleLabel.topAnchor.constraint(equalTo: settingsTitleLabel.bottomAnchor, constant: 28),
            infoTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            decimalDisplayButton.centerYAnchor.constraint(equalTo: infoTitleLabel.centerYAnchor),
            decimalDisplayButton.trailingAnchor.constraint(equalTo: versionDividerView.trailingAnchor),
            decimalDisplayButton.heightAnchor.constraint(equalToConstant: 22),
            
            settingsDividerView.topAnchor.constraint(equalTo: infoTitleLabel.bottomAnchor, constant: 28),
            settingsDividerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            settingsDividerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            
        ])
    }
    
    private func configureConfirmButton() {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .systemGray
        
        let attributes =  AttributeContainer([
            .font: UIFont.systemFont(ofSize: 14, weight: .regular)
        ])
        
        config.attributedTitle = AttributedString("소수점 표시", attributes: attributes)
        config.image = UIImage(systemName: "chevron.right")?.withConfiguration(
            UIImage.SymbolConfiguration(pointSize: 10, weight: .semibold)
        )
        config.imagePadding = 12
        config.imagePlacement = .trailing
        
        decimalDisplayButton.configuration = config
        decimalDisplayButton.menu = makeDecimalDisplayMenu()
        decimalDisplayButton.showsMenuAsPrimaryAction = true
    }
    
    private func makeDecimalDisplayMenu() -> UIMenu {
        let actions = [1, 2, 3, 4, 5, 6].map { places in
            UIAction(
                title: "\(places) 자리",
                state: isCurrentDecimalPlaces(places) ? .on : .off
            ) { _ in
                Double.updateDecimalPlaces(places)
                self.decimalDisplayButton.menu = self.makeDecimalDisplayMenu()
            }
        }
        
        return UIMenu(title: "소수점 자릿수 설정", children: actions)
    }
    
    private func isCurrentDecimalPlaces(_ places: Int) -> Bool {
        let currentPlaces = UserDefaults.standard.integer(forKey: "DecimalPlaces").nonZero ?? 1
        return currentPlaces == places
    }

}

#if DEBUG
import SwiftUI

#Preview {
    MoreMenuViewController().toPreview()
}

#endif

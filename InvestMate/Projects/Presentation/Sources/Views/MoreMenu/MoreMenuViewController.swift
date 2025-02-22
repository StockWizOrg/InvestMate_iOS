//
//  MoreMenuViewController.swift
//  Presentation
//
//  Created by 조호근 on 1/31/25.
//

import UIKit
import MessageUI

import Domain

class MoreMenuViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let versionTitleLabel = UILabel()
    private let versionValueLabel = UILabel()
    private let versionDividerView = UIView()
    private let settingsTitleLabel = UILabel()
    private let infoTitleLabel = UILabel()
    private let decimalDisplayButton = UIButton()
    private let settingsDividerView = UIView()
    private let customerSupportLabel = UILabel()
    private let contactUsTitleLabel = UILabel()
    private let contactUsButton = UIButton()
    private let rateAppTitleLabel = UILabel()
    private let rateAppButton = UIButton()
    private let shareAppTitleLabel = UILabel()
    private let shareAppButton = UIButton()
    
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
    let appID = "6741756312"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setUI()
        setLayout()
        configureButtons()
    }
    

    private func setStyle() {
        self.title = String(localized: "More", bundle: .module)
        self.view.backgroundColor = .systemGray6
        scrollView.showsVerticalScrollIndicator = false
        
        versionTitleLabel.configureTitleLabel(
            title: String(localized: "App Version Info", bundle: .module),
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
            title: String(localized: "Settings", bundle: .module),
            ofSize: 16,
            weight: .bold
        )
        
        infoTitleLabel.configureTitleLabel(
            title: String(localized: "Information Display Settings", bundle: .module),
            ofSize: 14,
            weight: .regular
        )
        infoTitleLabel.textColor = .black
        
        customerSupportLabel.configureTitleLabel(
            title: String(localized: "Customer Support", bundle: .module),
            ofSize: 16,
            weight: .bold
        )
        
        contactUsTitleLabel.configureTitleLabel(
            title: String(localized: "Contact Us", bundle: .module),
            ofSize: 14,
            weight: .regular
        )
        
        rateAppTitleLabel.configureTitleLabel(
            title: String(localized: "Rate This App", bundle: .module),
            ofSize: 14,
            weight: .regular
        )
        
        shareAppTitleLabel.configureTitleLabel(
            title: String(localized: "Share App", bundle: .module),
            ofSize: 14,
            weight: .regular
        )
        
        [versionDividerView, settingsDividerView].forEach {
            $0.configureDivider()
        }
        
    }
    
    private func setUI() {
        view.addSubviews(scrollView)
        scrollView.addSubviews(contentView)
        
        contentView.addSubviews(
            versionTitleLabel,
            versionValueLabel,
            versionDividerView,
            settingsTitleLabel,
            infoTitleLabel,
            decimalDisplayButton,
            settingsDividerView,
            customerSupportLabel,
            contactUsTitleLabel,
            contactUsButton,
            rateAppTitleLabel,
            rateAppButton,
            shareAppTitleLabel,
            shareAppButton
        )
    }
    
    private func setLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            versionTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            versionTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            versionValueLabel.topAnchor.constraint(equalTo: versionTitleLabel.bottomAnchor, constant: 28),
            versionValueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            versionDividerView.topAnchor.constraint(equalTo: versionValueLabel.bottomAnchor, constant: 28),
            versionDividerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            versionDividerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            settingsTitleLabel.topAnchor.constraint(equalTo: versionDividerView.bottomAnchor, constant: 28),
            settingsTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            infoTitleLabel.topAnchor.constraint(equalTo: settingsTitleLabel.bottomAnchor, constant: 28),
            infoTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            decimalDisplayButton.centerYAnchor.constraint(equalTo: infoTitleLabel.centerYAnchor),
            decimalDisplayButton.trailingAnchor.constraint(equalTo: versionDividerView.trailingAnchor),
            decimalDisplayButton.heightAnchor.constraint(equalToConstant: 22),
            
            settingsDividerView.topAnchor.constraint(equalTo: infoTitleLabel.bottomAnchor, constant: 28),
            settingsDividerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            settingsDividerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            customerSupportLabel.topAnchor.constraint(equalTo: settingsDividerView.bottomAnchor, constant: 28),
            customerSupportLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            contactUsTitleLabel.topAnchor.constraint(equalTo: customerSupportLabel.bottomAnchor, constant: 28),
            contactUsTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            contactUsButton.centerYAnchor.constraint(equalTo: contactUsTitleLabel.centerYAnchor),
            contactUsButton.trailingAnchor.constraint(equalTo: versionDividerView.trailingAnchor),
            contactUsButton.heightAnchor.constraint(equalToConstant: 22),
            
            rateAppTitleLabel.topAnchor.constraint(equalTo: contactUsTitleLabel.bottomAnchor, constant: 28),
            rateAppTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            rateAppButton.centerYAnchor.constraint(equalTo: rateAppTitleLabel.centerYAnchor),
            rateAppButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            rateAppButton.heightAnchor.constraint(equalToConstant: 22),
            
            shareAppTitleLabel.topAnchor.constraint(equalTo: rateAppTitleLabel.bottomAnchor, constant: 28),
            shareAppTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            shareAppButton.centerYAnchor.constraint(equalTo: shareAppTitleLabel.centerYAnchor),
            shareAppButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            shareAppButton.heightAnchor.constraint(equalToConstant: 22),
            shareAppButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
            
        ])
    }
    
    private func configureButtons() {
        decimalDisplayButton.configureMoreMenuButton(title:  String(localized: "Decimal Display", bundle: .module))
        decimalDisplayButton.menu = makeDecimalDisplayMenu()
        decimalDisplayButton.showsMenuAsPrimaryAction = true
        
        contactUsButton.configureMoreMenuButton(title: String(localized: "Ask a Question", bundle: .module))
        contactUsButton.addAction(
            UIAction { [weak self] _ in
                self?.handleContactUs()
            },
            for: .touchUpInside
        )
        
        rateAppButton.configureMoreMenuButton(title: String(localized: "Write a Review", bundle: .module))
        rateAppButton.addAction(
            UIAction { [weak self] _ in
                self?.handleRateApp()
            },
            for: .touchUpInside
        )
        
        shareAppButton.configureMoreMenuButton(title: String(localized: "Recommend This App", bundle: .module))
        shareAppButton.addAction(
            UIAction { [weak self] _ in
                self?.handleShare()
            },
            for: .touchUpInside
        )
    }
    
}

extension MoreMenuViewController {
    
    private func makeDecimalDisplayMenu() -> UIMenu {
        let actions = [1, 2, 3, 4, 5, 6].map { places in
            UIAction(
                title: String(localized: "\(places) digits", bundle: .module),
                state: isCurrentDecimalPlaces(places) ? .on : .off
            ) { _ in
                Double.updateDecimalPlaces(places)
                self.decimalDisplayButton.menu = self.makeDecimalDisplayMenu()
            }
        }
        
        return UIMenu(title: String(localized: "Decimal Places Settings", bundle: .module), children: actions)
    }
    
    private func isCurrentDecimalPlaces(_ places: Int) -> Bool {
        let currentPlaces = UserDefaults.standard.integer(forKey: "DecimalPlaces").nonZero ?? 1
        return currentPlaces == places
    }
    
    private func handleContactUs() {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeVC = MFMailComposeViewController()
            mailComposeVC.mailComposeDelegate = self
            
            mailComposeVC.setToRecipients(["josama2022.dev@gmail.com"])
            mailComposeVC.setSubject("[InvestMate] \(String(localized: "Contact Us", bundle: .module))")
            
            let deviceInfo = """
                
                \(String(localized: "Please write your message here.", bundle: .module))
                
                
                ================================
                App Version : \(appVersion)
                Device Model : \(UIDevice.current.model)
                Device OS : \(UIDevice.current.systemVersion)
                ================================
                """
            
            mailComposeVC.setMessageBody(deviceInfo, isHTML: false)
            present(mailComposeVC, animated: true)
        } else {
            self.showMailErrorAlert()
        }
    }
    
    private func showMailErrorAlert() {
        let alert = UIAlertController(
            title: String(localized: "Email Account Required", bundle: .module),
            message: String(localized: "Please configure your email account in the Mail app.", bundle: .module),
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: String(localized: "Confirm", bundle: .module), style: .default))
        present(alert, animated: true)
    }
    
    private func handleRateApp() {
        guard let url = URL(string: "https://apps.apple.com/app/id\(appID)?action=write-review") else {
            return
        }
        
        UIApplication.shared.open(url)
    }
    
    private func handleShare() {
        let appStoreURL = "https://apps.apple.com/app/id\(appID)?action=write-review"
        let message = """
                [InvestMate]
                \(String(localized: "Stock Averaging Calculator", bundle: .module)) 📈
                \(String(localized: "Plan a rational buying strategy!", bundle: .module))
                
                """
        
        let itemsToShare: [Any] = [
            message,
            appStoreURL
        ]
        
        let activityVC = UIActivityViewController(
            activityItems: itemsToShare,
            applicationActivities: nil
        )
        
        present(activityVC, animated: true)
    }
    
}

extension MoreMenuViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
}

#if DEBUG
import SwiftUI

#Preview {
    MoreMenuViewController().toPreview()
}

#endif

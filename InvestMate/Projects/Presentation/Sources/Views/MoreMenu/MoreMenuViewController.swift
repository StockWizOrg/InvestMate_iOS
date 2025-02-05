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
    let appID = "idYOUR_APP_ID"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyle()
        setUI()
        setLayout()
        configureButtons()
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
        infoTitleLabel.textColor = .black
        
        customerSupportLabel.configureTitleLabel(
            title: "고객 지원",
            ofSize: 16,
            weight: .bold
        )
        
        contactUsTitleLabel.configureTitleLabel(
            title: "서비스 이용 문의",
            ofSize: 14,
            weight: .regular
        )
        
        rateAppTitleLabel.configureTitleLabel(
            title: "앱스토어 리뷰",
            ofSize: 14,
            weight: .regular
        )
        
        shareAppTitleLabel.configureTitleLabel(
            title: "앱 추천하기",
            ofSize: 14,
            weight: .regular
        )
        
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
            
            customerSupportLabel.topAnchor.constraint(equalTo: settingsDividerView.bottomAnchor, constant: 28),
            customerSupportLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            contactUsTitleLabel.topAnchor.constraint(equalTo: customerSupportLabel.bottomAnchor, constant: 28),
            contactUsTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            contactUsButton.centerYAnchor.constraint(equalTo: contactUsTitleLabel.centerYAnchor),
            contactUsButton.trailingAnchor.constraint(equalTo: versionDividerView.trailingAnchor),
            contactUsButton.heightAnchor.constraint(equalToConstant: 22),
            
            rateAppTitleLabel.topAnchor.constraint(equalTo: contactUsTitleLabel.bottomAnchor, constant: 28),
            rateAppTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            rateAppButton.centerYAnchor.constraint(equalTo: rateAppTitleLabel.centerYAnchor),
            rateAppButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            rateAppButton.heightAnchor.constraint(equalToConstant: 22),
            
            shareAppTitleLabel.topAnchor.constraint(equalTo: rateAppTitleLabel.bottomAnchor, constant: 28),
            shareAppTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            shareAppButton.centerYAnchor.constraint(equalTo: shareAppTitleLabel.centerYAnchor),
            shareAppButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            shareAppButton.heightAnchor.constraint(equalToConstant: 22)
            
        ])
    }
    
    private func configureButtons() {
        decimalDisplayButton.configureMoreMenuButton(title: "소수점 표시")
        decimalDisplayButton.menu = makeDecimalDisplayMenu()
        decimalDisplayButton.showsMenuAsPrimaryAction = true
        
        contactUsButton.configureMoreMenuButton(title: "문의하기")
        contactUsButton.addAction(
            UIAction { [weak self] _ in
                self?.handleContactUs()
            },
            for: .touchUpInside
        )
        
        rateAppButton.configureMoreMenuButton(title: "평가하기")
        rateAppButton.addAction(
            UIAction { [weak self] _ in
                self?.handleRateApp()
            },
            for: .touchUpInside
        )
        
        shareAppButton.configureMoreMenuButton(title: "공유하기")
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
    
    private func handleContactUs() {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeVC = MFMailComposeViewController()
            mailComposeVC.mailComposeDelegate = self
            
            mailComposeVC.setToRecipients(["josama2022.dev@gmail.com"])
            mailComposeVC.setSubject("[InvestMate] 문의하기")
            
            let deviceInfo = """
                
                이곳에 내용을 작성해주세요
                
                
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
            title: "메일 계정 활성화 필요",
            message: "Mail 앱에서 사용자의 Email을 계정을 설정해 주세요.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    private func handleRateApp() {
        // TODO: 실제 앱 ID로 교체하기
        
        guard let url = URL(string: "https://apps.apple.com/app/id\(appID)?action=write-review") else {
            return
        }
        
        UIApplication.shared.open(url)
    }
    
    private func handleShare() {
        let appStoreURL = "https://apps.apple.com/app/id\(appID)?action=write-review"
        let message = """
                [InvestMate]
                주식 물타기 계산기 📈
                합리적인 매수 전략을 세워보세요!
                
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

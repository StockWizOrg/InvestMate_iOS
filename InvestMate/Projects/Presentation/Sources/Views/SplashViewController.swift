//
//  SplashViewController.swift
//  Presentation
//
//  Created by 조호근 on 5/29/25.
//

import UIKit

public class SplashViewController: UIViewController {
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()

    public override func viewDidLoad() {
        super.viewDidLoad()

        setStyle()
        setUI()
        setLayout()
    }
    
    private func setStyle() {
        imageView.image = UIImage(named: "Group 9")
        imageView.contentMode = .scaleAspectFit
        
        titleLabel.text = "InvestMate"
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = .white
        
        view.backgroundColor = UIColor(red: 0.059, green: 0.059, blue: 0.153, alpha: 1.0)
    }
    
    private func setUI() {
        view.addSubviews(imageView, titleLabel)
    }
    
    private func setLayout() {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 68),
            imageView.heightAnchor.constraint(equalToConstant: 59),
            imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 375),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

}

#if DEBUG
import SwiftUI

#Preview {
    SplashViewController().toPreview()
}
#endif

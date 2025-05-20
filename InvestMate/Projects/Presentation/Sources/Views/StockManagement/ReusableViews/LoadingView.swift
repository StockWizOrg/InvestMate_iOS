//
//  LoadingView.swift
//  Presentation
//
//  Created by 조호근 on 5/21/25.
//

import UIKit

final class LoadingView: UIView {
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.color = .gray
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
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
        isHidden = true
    }
    
    private func setUI() {
        addSubview(loadingIndicator)
    }
    
    private func setLayout() {
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func startLoading() {
        isHidden = false
        loadingIndicator.startAnimating()
    }
    
    func stopLoading() {
        isHidden = true
        loadingIndicator.stopAnimating()
    }
}

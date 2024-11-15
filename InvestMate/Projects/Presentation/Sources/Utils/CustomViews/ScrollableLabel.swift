//
//  ScrollableLabel.swift
//  Presentation
//
//  Created by 조호근 on 11/16/24.
//

import UIKit

class ScrollableLabel: UIView {

    private let scrollView = UIScrollView()
    private let label = UILabel()
    
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
        scrollView.backgroundColor = .systemBackground
        scrollView.alpha = 0.6
        scrollView.showsHorizontalScrollIndicator = false
        
        label.configureNumericLabel()
        label.backgroundColor = .clear
        label.text = "0"
        label.textColor = .placeholderText
    }
    
    private func setUI() {
        self.addSubviews(scrollView)
        scrollView.addSubviews(label)
    }
    
    private func setLayout() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            label.topAnchor.constraint(equalTo: scrollView.topAnchor),
            label.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 18),
            label.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -18),
            label.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            label.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
    }

    func setText(_ text: String?) {
        if let text = text, !text.isEmpty {
            label.text = text
            label.textColor = .black
        } else {
            label.text = "0"
            label.textColor = .gray
        }
        
        scrollView.contentSize = label.intrinsicContentSize
    }
    
}

#if DEBUG
import SwiftUI

#Preview {
    ScrollableLabel().toPreview()
}

#endif

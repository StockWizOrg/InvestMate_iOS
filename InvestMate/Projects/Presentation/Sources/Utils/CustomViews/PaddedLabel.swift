//
//  PaddedLabel.swift
//  Presentation
//
//  Created by 조호근 on 11/15/24.
//

import UIKit

final class PaddedLabel: UILabel {
    
    var textInsets: UIEdgeInsets

    init(textInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)) {
        self.textInsets = textInsets
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func drawText(in rect: CGRect) {
        let paddedRect = rect.inset(by: textInsets)
        super.drawText(in: paddedRect)
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(
            width: size.width + textInsets.left + textInsets.right,
            height: size.height + textInsets.top + textInsets.bottom
        )
    }
}

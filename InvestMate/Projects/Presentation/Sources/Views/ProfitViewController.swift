//
//  ProfitViewController.swift
//  Presentation
//
//  Created by 조호근 on 10/28/24.
//

import UIKit

public class ProfitViewController: UIViewController {

    private let purchasePriceLabel = UILabel()
    private let averagePriceView = LabeledTextFieldView(title: "평균단가", placeholder: "금액")
    private let sellQuantityLabel = UILabel()
    private let quantityView = LabeledTextFieldView(title: "수량", placeholder: "수량")
    private let salePriceLabel = UILabel()
    private let salePriceView = LabeledTextFieldView(title: "평균단가", placeholder: "금액")
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    private func setStyle() {
        self.view.backgroundColor = .systemGray6
        
        purchasePriceLabel.configureLabel(title: "매수단가", ofSize: 20, weight: .bold)
        sellQuantityLabel.configureLabel(title: "매도수량", ofSize: 20, weight: .bold)
        salePriceLabel.configureLabel(title: "매도단가", ofSize: 20, weight: .bold)
        
    }
   
}

#if DEBUG
import SwiftUI

#Preview {
    ProfitViewController().toPreview()
}
#endif

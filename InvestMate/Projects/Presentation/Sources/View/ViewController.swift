//
//  ViewController.swift
//  InvestMate
//
//  Created by 조호근 on 8/26/24.
//

import UIKit
import Domain

public class ViewController: UIViewController {
    
    let viewModel: StockViewModel
    
    public init(viewModel: StockViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        // Interface Builder를 사용하지 않는다면 fatalError를 사용합니다.
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let stockNames = viewModel.getStockNames()
        
        let label = UILabel()
        label.text = "Stocks: \(stockNames.joined(separator: ", "))"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

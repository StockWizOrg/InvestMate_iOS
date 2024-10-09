//
//  ViewController.swift
//  InvestMate
//
//  Created by 조호근 on 8/26/24.
//

import UIKit

public class ViewController: UIViewController {
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemPink
        setUI()
    }
    
    private func setUI() {
        
    }
}

#if DEBUG
import SwiftUI

#Preview {
    ViewController().toPreview()
}
#endif

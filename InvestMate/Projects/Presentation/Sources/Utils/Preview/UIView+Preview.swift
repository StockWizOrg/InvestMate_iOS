//
//  UIView+.swift
//  Presentation
//
//  Created by 조호근 on 10/9/24.
//



#if DEBUG
import SwiftUI

extension UIView {
    
    private struct Preview: UIViewRepresentable {
        let view: UIView
        
        func makeUIView(context: Context) -> UIView {
            return view
        }
        
        func updateUIView(_ uiView: UIView, context: Context) { }
    }
    
    func toPreview() -> some View {
        Preview(view: self)
    }
}
#endif

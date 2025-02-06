//
//  Encodable+.swift
//  Presentation
//
//  Created by 조호근 on 1/4/25.
//

import Foundation

extension Encodable {
    
    var prettyJSON: String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        
        guard let data = try? encoder.encode(self),
              let output = String(data: data, encoding: .utf8)
        else {
            return "Error: Failed to encode"
        }
        
        return output
    }
    
    func debugLog(label: String? = nil) {
        if let label = label {
            print("\n=== \(label) ===")
        }
        print(prettyJSON)
        if label != nil {
            print("================\n")
        }
    }
    
}

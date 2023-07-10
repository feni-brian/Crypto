//
//  String.swift
//  SwiftfulCrypto
//
//  Created by Nick Sarno on 5/14/21.
//  Modified by Feni Brian on 6/6/22.
//

import Foundation

extension String {
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
}

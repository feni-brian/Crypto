//
//  UIApplication.swift
//  SwiftfulCrypto
//
//  Created by Nick Sarno on 5/9/21.
//  Modified by Feni Brian on 6/6/22.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

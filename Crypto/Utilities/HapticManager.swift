//
//  HapticManager.swift
//  Crypto
//
//  Created by Feni Brian on 22/06/2022.
//

import Foundation
import SwiftUI

class HapticManager {
    static private let generator = UINotificationFeedbackGenerator()
    
    static func notify(for type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
}

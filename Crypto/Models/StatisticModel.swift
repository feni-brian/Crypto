//
//  StatisticModel.swift
//  Crypto
//
//  Created by Feni Brian on 18/06/2022.
//

import Foundation

struct StatisticModel: Identifiable {
    var id = UUID().uuidString
    var title: String
    var value: String
    var percentageChange: Double?
    
    init(title: String, value: String, percentageChange: Double? = nil) {
        self.title = title
        self.value = value
        self.percentageChange = percentageChange
    }
}

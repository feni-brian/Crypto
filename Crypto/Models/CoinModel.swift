//
//  CoinModel.swift
//  Crypto
//
//  Created by Feni Brian on 07/06/2022.
//

import Foundation
import SwiftUI

/*
 CURL : curl -X 'GET' \
 'https://api.coingecko.com/api/v3/coins/markets?vs_currency=eur&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h' \
 -H 'accept: application/json'
 
 REQUEST URL : https://api.coingecko.com/api/v3/coins/markets?vs_currency=eur&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h
 */

// MARK: - CoinModel
struct CoinModel: Identifiable, Codable {
    let id, symbol, name: String?
    let image: String?
    let currentPrice, marketCap, marketCapRank, fullyDilutedValuation: Double?
    let totalVolume, high24H, low24H: Double?
    let priceChange24H, priceChangePercentage24H, marketCapChange24H, marketCapChangePercentage24H: Double?
    let circulatingSupply, totalSupply, maxSupply, ath: Double?
    let athChangePercentage: Double?
    let athDate: String?
    let atl, atlChangePercentage: Double?
    let atlDate: String?
    let roi: Roi?
    let lastUpdated: String?
    let sparklineIn7D: SparklineIn7D?
    let priceChangePercentage24HInCurrency: Double?
    let currentHoldings: Double?

    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case fullyDilutedValuation = "fully_diluted_valuation"
        case totalVolume = "total_volume"
        case high24H = "high_24h"
        case low24H = "low_24h"
        case priceChange24H = "price_change_24h"
        case priceChangePercentage24H = "price_change_percentage_24h"
        case marketCapChange24H = "market_cap_change_24h"
        case marketCapChangePercentage24H = "market_cap_change_percentage_24h"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case ath
        case athChangePercentage = "ath_change_percentage"
        case athDate = "ath_date"
        case atl
        case atlChangePercentage = "atl_change_percentage"
        case atlDate = "atl_date"
        case roi
        case lastUpdated = "last_updated"
        case sparklineIn7D = "sparkline_in_7d"
        case priceChangePercentage24HInCurrency = "price_change_percentage_24h_in_currency"
        case currentHoldings
    }
    
    func updateHoldings(amount: Double) -> CoinModel {
        return CoinModel(id: id, symbol: symbol, name: name, image: image, currentPrice: currentPrice, marketCap: marketCap, marketCapRank: marketCapRank, fullyDilutedValuation: fullyDilutedValuation, totalVolume: totalVolume, high24H: high24H, low24H: low24H, priceChange24H: priceChange24H, priceChangePercentage24H: priceChangePercentage24H, marketCapChange24H: marketCapChange24H, marketCapChangePercentage24H: marketCapChangePercentage24H, circulatingSupply: circulatingSupply, totalSupply: totalSupply, maxSupply: maxSupply, ath: ath, athChangePercentage: athChangePercentage, athDate: athDate, atl: atl, atlChangePercentage: atlChangePercentage, atlDate: atlDate, roi: roi, lastUpdated: lastUpdated, sparklineIn7D: sparklineIn7D, priceChangePercentage24HInCurrency: priceChangePercentage24HInCurrency, currentHoldings: amount)
    }
    
    var currentHoldingsValue: Double {
        return (currentHoldings ?? 0) * (currentPrice ?? 0)
    }
    var rank: Int {
        return Int(marketCapRank ?? 0)
    }
    
}

// MARK: - CoinModel convenience initializers and mutators
extension CoinModel {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(CoinModel.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        id: String?? = nil,
        symbol: String?? = nil,
        name: String?? = nil,
        image: String?? = nil,
        currentPrice: Double?? = nil,
        marketCap: Double?? = nil,
        marketCapRank: Double?? = nil,
        fullyDilutedValuation: Double?? = nil,
        totalVolume: Double?? = nil,
        high24H: Double?? = nil,
        low24H: Double?? = nil,
        priceChange24H: Double?? = nil,
        priceChangePercentage24H: Double?? = nil,
        marketCapChange24H: Double?? = nil,
        marketCapChangePercentage24H: Double?? = nil,
        circulatingSupply: Double?? = nil,
        totalSupply: Double?? = nil,
        maxSupply: Double?? = nil,
        ath: Double?? = nil,
        athChangePercentage: Double?? = nil,
        athDate: String?? = nil,
        atl: Double?? = nil,
        atlChangePercentage: Double?? = nil,
        atlDate: String?? = nil,
        roi: Roi?? = nil,
        lastUpdated: String?? = nil,
        sparklineIn7D: SparklineIn7D?? = nil,
        priceChangePercentage24HInCurrency: Double?? = nil,
        currentHoldings: Double?? = nil
    ) -> CoinModel {
        return CoinModel(
            id: id ?? self.id,
            symbol: symbol ?? self.symbol,
            name: name ?? self.name,
            image: image ?? self.image,
            currentPrice: currentPrice ?? self.currentPrice,
            marketCap: marketCap ?? self.marketCap,
            marketCapRank: marketCapRank ?? self.marketCapRank,
            fullyDilutedValuation: fullyDilutedValuation ?? self.fullyDilutedValuation,
            totalVolume: totalVolume ?? self.totalVolume,
            high24H: high24H ?? self.high24H,
            low24H: low24H ?? self.low24H,
            priceChange24H: priceChange24H ?? self.priceChange24H,
            priceChangePercentage24H: priceChangePercentage24H ?? self.priceChangePercentage24H,
            marketCapChange24H: marketCapChange24H ?? self.marketCapChange24H,
            marketCapChangePercentage24H: marketCapChangePercentage24H ?? self.marketCapChangePercentage24H,
            circulatingSupply: circulatingSupply ?? self.circulatingSupply,
            totalSupply: totalSupply ?? self.totalSupply,
            maxSupply: maxSupply ?? self.maxSupply,
            ath: ath ?? self.ath,
            athChangePercentage: athChangePercentage ?? self.athChangePercentage,
            athDate: athDate ?? self.athDate,
            atl: atl ?? self.atl,
            atlChangePercentage: atlChangePercentage ?? self.atlChangePercentage,
            atlDate: atlDate ?? self.atlDate,
            roi: roi ?? self.roi,
            lastUpdated: lastUpdated ?? self.lastUpdated,
            sparklineIn7D: sparklineIn7D ?? self.sparklineIn7D,
            priceChangePercentage24HInCurrency: priceChangePercentage24HInCurrency ?? self.priceChangePercentage24HInCurrency,
            currentHoldings: currentHoldings ?? self.currentHoldings
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Roi
struct Roi: Codable {
    let times: Double?
    let currency: String?
    let percentage: Double?
}

// MARK: - Roi convenience initializers and mutators
extension Roi {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Roi.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        times: Double?? = nil,
        currency: String?? = nil,
        percentage: Double?? = nil
    ) -> Roi {
        return Roi(
            times: times ?? self.times,
            currency: currency ?? self.currency,
            percentage: percentage ?? self.percentage
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - SparklineIn7D
struct SparklineIn7D: Codable {
    let price: [Double]?
}

// MARK: - SparklineIn7D convenience initializers and mutators
extension SparklineIn7D {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(SparklineIn7D.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        price: [Double]?? = nil
    ) -> SparklineIn7D {
        return SparklineIn7D(
            price: price ?? self.price
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

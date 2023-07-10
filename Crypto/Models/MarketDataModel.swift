//
//  MarketDataModel.swift
//  Crypto
//
//  Created by Feni Brian on 18/06/2022.
//

import Foundation

/*
 curl -X 'GET' \
   'https://api.coingecko.com/api/v3/global' \
   -H 'accept: application/json'
 
 REQUEST URL :
    https://api.coingecko.com/api/v3/global
*/

// MARK: - GlobalDataModel
struct GlobalDataModel: Codable {
    let data: MarketDataModel?
}

// MARK: GlobalDataModel convenience initializers and mutators

extension GlobalDataModel {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(GlobalDataModel.self, from: data)
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
        data: MarketDataModel?? = nil
    ) -> GlobalDataModel {
        return GlobalDataModel(
            data: data ?? self.data
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - MarketDataModel
struct MarketDataModel: Codable {
    let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]?
    let marketCapChangePercentage24HUsd: Double?
    
    enum CodingKeys: String, CodingKey {
        case totalMarketCap = "total_market_cap"
        case totalVolume = "total_volume"
        case marketCapPercentage = "market_cap_percentage"
        case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24_usd"
    }
    
    var marketCap: String? {
        if let item = totalMarketCap?.first(where: { $0.key == "eur" }) {
            return "€ " + item.value.formattedWithAbbreviations()
        }
        return nil
    }
    
    var volume: String? {
        if let item = totalVolume?.first(where: { $0.key == "eur" }) {
            return "€ " + item.value.formattedWithAbbreviations()
        }
        return nil
    }
    
    var btcDominance: String? {
        if let item = marketCapPercentage?.first(where: { $0.key == "btc" }) {
            return item.value.asPercentString()
        }
        return nil
    }
}

// MARK: MarketDataModel convenience initializers and mutators

extension MarketDataModel {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(MarketDataModel.self, from: data)
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
        totalMarketCap: [String: Double]?? = nil,
        totalVolume: [String: Double]?? = nil,
        marketCapPercentage: [String: Double]?? = nil,
        marketCapChangePercentage24HUsd: Double?? = nil
    ) -> MarketDataModel {
        return MarketDataModel(
            totalMarketCap: totalMarketCap ?? self.totalMarketCap,
            totalVolume: totalVolume ?? self.totalVolume,
            marketCapPercentage: marketCapPercentage ?? self.marketCapPercentage,
            marketCapChangePercentage24HUsd: marketCapChangePercentage24HUsd ?? self.marketCapChangePercentage24HUsd
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}



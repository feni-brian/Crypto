//
//  CoinDetailModel.swift
//  Crypto
//
//  Created by Feni Brian on 24/06/2022.
//

import Foundation

/*
 curl -X 'GET' \
   'https://api.coingecko.com/api/v3/coins/bitcoin?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false' \
   -H 'accept: application/json'
 
 Request URL:
    'https://api.coingecko.com/api/v3/coins/bitcoin?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false'
 */

// MARK: - CoinDataModel
struct CoinDetailModel: Codable {
    let id, symbol, name: String?
    let blockTimeInMinutes: Int?
    let hashingAlgorithm: String?
    let description: Description?
    let links: Links?
    var legibleDescription: String? {
        return description?.en?.removingHTMLOccurances
    }

    enum CodingKeys: String, CodingKey {
        case id, symbol, name
        case blockTimeInMinutes = "block_time_in_minutes"
        case hashingAlgorithm = "hashing_algorithm"
        case description = "description"
        case links
    }
}

// MARK: CoinDataModel convenience initializers and mutators
extension CoinDetailModel {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(CoinDetailModel.self, from: data)
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
        blockTimeInMinutes: Int?? = nil,
        hashingAlgorithm: String?? = nil,
        description: Description?? = nil,
        links: Links?? = nil
    ) -> CoinDetailModel {
        return CoinDetailModel(
            id: id ?? self.id,
            symbol: symbol ?? self.symbol,
            name: name ?? self.name,
            blockTimeInMinutes: blockTimeInMinutes ?? self.blockTimeInMinutes,
            hashingAlgorithm: hashingAlgorithm ?? self.hashingAlgorithm,
            description: description ?? self.description,
            links: links ?? self.links
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Description
struct Description: Codable {
    let en: String?
}

// MARK: Description convenience initializers and mutators
extension Description {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Description.self, from: data)
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

    func with(en: String?? = nil) -> Description {
        return Description(en: en ?? self.en)
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Links
struct Links: Codable {
    let homepage: [String]?
    let subredditURL: String?

    enum CodingKeys: String, CodingKey {
        case homepage
        case subredditURL = "subreddit_url"
    }
}

// MARK: Links convenience initializers and mutators
extension Links {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Links.self, from: data)
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

    func with(homepage: [String]?? = nil, subredditURL: String?? = nil) -> Links {
        return Links(
            homepage: homepage ?? self.homepage,
            subredditURL: subredditURL ?? self.subredditURL
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

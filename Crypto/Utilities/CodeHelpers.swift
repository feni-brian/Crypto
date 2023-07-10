//
//  CodeHelpers.swift
//  Crypto
//
//  Created by Feni Brian on 18/06/2022.
//

import Foundation

// MARK: - Helper functions for creating encoders and decoders
func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

// MARK: - Encode/decode helpers
/*
 This value is used to replace the 'null' value typically used in JSON objects.
 For example:
    "roi" : null  -> in JSON file becomes,
    roi : JSONNull  -> in the swift model file.
 I chose to go with Double in this case.
 */
class JSONNull: Codable, Hashable {
    
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }
    
/*
 Since 'Hashable:hashValue' is deprecated as a protocol requirement; we thus instead conform type 'ActiveType' to 'Hashable' by
 implementing 'hash(into:).
 */
//    public var hashValue: Int {
//        return 0
//    }
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(0)
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}


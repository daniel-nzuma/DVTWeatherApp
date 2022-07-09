//
//  JSONAny.swift
//  networkingCore
//
//  Created by Daniel Nzuma on 06/07/2022.
//

import Foundation

enum JsonAny: Codable {
    case double(Double)
    case string(String)
    case int(Int)
    case bool(Bool)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            self = try .double(container.decode(Double.self))
        } catch DecodingError.typeMismatch {
            do {
                self = try .int(container.decode(Int.self))
            } catch DecodingError.typeMismatch {
                do {
                    self = try .string(container.decode(String.self))
                } catch DecodingError.typeMismatch {
                    do {
                        self = try .bool(container.decode(Bool.self))
                    } catch DecodingError.typeMismatch {
                        throw DecodingError.typeMismatch(JsonAny.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Encoded payload not of an expected decodable types"))
                    }
                }
            }
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .double(let double):
            try container.encode(double)
        case .string(let string):
            try container.encode(string)
        case .int(let int):
            try container.encode(int)
        case .bool(let bool):
            try container.encode(bool)
        }
    }
}

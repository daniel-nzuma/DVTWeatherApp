//
//  DefaultApiRequest.swift
//  networkingCore
//
//  Created by Daniel Nzuma on 06/07/2022.
//

import Foundation

public class DefaultApiRequest : NSObject, Codable {
    /// Dictionary object with extension-specific objects.
    public var service:String?=""
    //
    public var imei:String? = ""
    //
    public var origin:String = "ios"
    //
    public var lang:String? = "en"
    
    private enum CodingKeys: String, CodingKey {
        case imei
        case service = "type"
        case lang
        case origin
    }
    
    public override init() {
        //
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        imei = try? container.decode(String.self, forKey: .imei)
        service = try? container.decode(String.self, forKey: .service)
        origin = try container.decode(String.self, forKey: .origin)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(imei , forKey: .imei)
        try? container.encode(service , forKey: .service)
        try? container.encode(origin , forKey: .origin)
        //try? container.encode(origin , forKey: .origin)
        try? container.encode(lang , forKey: .lang)
    }
}

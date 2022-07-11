//
//  PhoneLookupRequest.swift
//  networkingCore
//
//  Created by Daniel Nzuma on 06/07/2022.
//

import Foundation

public class GetWeatherRequest : DefaultApiRequest {
    //
    public var latitude:String = ""
    public var longitude:String = ""
    
    private enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
    }
    
    public override init() {
        super.init()
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        latitude = try container.decode(String.self, forKey: .latitude)
        longitude = try container.decode(String.self, forKey: .longitude)
        try super.init(from: decoder)
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(latitude , forKey: .latitude)
        try? container.encode(longitude , forKey: .longitude)
        try super.encode(to: encoder)
    }
}

//
//  PhoneLookupRequest.swift
//  networkingCore
//
//  Created by Daniel Nzuma on 06/07/2022.
//

import Foundation

class PhoneLookupRequest : DefaultApiRequest {
    //
    public var phone:String = ""
    public var email:String = ""
    
    private enum CodingKeys: String, CodingKey {
        case phone
        case email
    }
    
    public override init() {
        //
        super.init()
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        phone = try container.decode(String.self, forKey: .phone)
        email = try container.decode(String.self, forKey: .email)
        try super.init(from: decoder)
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(phone , forKey: .phone)
        try? container.encode(email , forKey: .email)
        try super.encode(to: encoder)
    }
}

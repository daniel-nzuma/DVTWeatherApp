//
//  PhoneLookupResponse.swift
//  networkingCore
//
//  Created by Daniel Nzuma on 06/07/2022.
//

import Foundation


class PhoneLookupResponse:Decodable{
    
    public var message:String?
    public var phone:String? = ""
    public var email:String? = ""
    public var isFirstLogin = false
    public var otp:String? = ""
    public var enforceOtp = true
    
    private enum CodingKeys: String, CodingKey {
        case phone,message
        case firstLogin = "isFirstLogin"
        case email
        case validateDevice = "enforceOtp"
        case otp
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let h = try container.decodeIfPresent(String.self, forKey: .phone){
            phone = h
        }
        if let h = try container.decodeIfPresent(String.self, forKey: .message){
            message = h
        }
        if let h = try container.decodeIfPresent(String.self, forKey: .email){
            email = h
        }
        if let h = try container.decodeIfPresent(Bool.self, forKey: .firstLogin){
            isFirstLogin = h
        }
        if let h = try container.decodeIfPresent(String.self, forKey: .otp){
            otp = h
        }
        if let h = try container.decodeIfPresent(Int.self, forKey: .validateDevice){
            enforceOtp = h > 0
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(phone , forKey: .phone)
    }
}

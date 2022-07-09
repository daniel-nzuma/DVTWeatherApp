//
//  ApiDefaultResponse.swift
//  networkingCore
//
//  Created by Daniel Nzuma on 06/07/2022.
//

import Foundation

class ApiDefaultResponse : NSObject, Codable {

    var status:Int = 0
    var errors:[String]?
    var message:String?
    var data:[String:JsonAny]?
    
    enum CodingKeys : String, CodingKey {
        case status = "success"
        case errors = "errors"
        case message = "message"
        case data = "data"
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let r  = try? container.decode(Bool.self, forKey: .status) {
            status = r ? 1 : 0
        }
        if let e = try? container.decode([String].self, forKey: .errors){
            self.errors = e
        }
        if let m = try? container.decodeIfPresent(String.self, forKey: .message){
            self.message = m
        }
        if let d = try? container.decodeIfPresent([String:JsonAny].self, forKey: .data){
            self.data = d
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(status , forKey: .status)
        try container.encode(errors , forKey: .errors)
        try container.encode(message , forKey: .message)
        try container.encode(data , forKey: .data)
    }
}

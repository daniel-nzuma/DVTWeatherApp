//
//  Utils.swift
//  networkingCore
//
//  Created by Daniel Nzuma on 09/07/2022.
//

import Foundation

public extension String{
    
    func base64Encoded() -> String? {
        return data(using: .utf8)?.base64EncodedString()
    }

    func base64Decoded() -> Data? {
        let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters)
        return data
    }

}

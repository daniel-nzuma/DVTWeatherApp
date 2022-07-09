//
//  APIServiceProtocol.swift
//  networkingCore
//
//  Created by Daniel Nzuma on 06/07/2022.
//

import Foundation

public protocol APIServiceProtocol:AnyObject {
    //
    func findUser(phone:String,email:String, _ completion: @escaping (_ status:Int,_ firstLogin:Bool?,_ otp:String?,_ enforceOtp:Bool?,_ msg:String?) -> Swift.Void) -> Swift.Void
    
    
}


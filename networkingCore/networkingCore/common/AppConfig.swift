//
//  AppConfig.swift
//  networkingCore
//
//  Created by Daniel Nzuma on 06/07/2022.
//

import Foundation
import CoreData

public class AppConfig:NSObject{
    
    public static let PINMaskingKey = "✦"
    public static let TOUCH_ID_MASK = "----"
    
    fileprivate static var _config: Config?
    var persistentContainer:NSPersistentContainer?
    
    public static var Current:Config?{
        get {
            if _config == nil {
                //Init...
                let _ = AppConfig()
            }
            
            return _config
        }
    }
     
    
    override init(){
        super.init()
        //
        do {
            //
            if let url = Bundle.main.url(forResource: "config", withExtension: "plist") {
                //
                let data = try Data(contentsOf: url)
                let config = try PropertyListDecoder().decode(Config.self, from: data)
                AppConfig._config = config
            }
        }catch{
             AppConfig._config = nil
            print(error)
            AppUtils.Log(from:self,with:"Load Config Error :: \(error)")
        }
    }
}

public struct Config: Decodable {
    private var environments : [AppEnvironment]
    //
    public var messages:AppMessages
    //
    public var services:AppServices
    
    public var Environment:AppEnvironment?{
        get{
            //Get the environment marked as active
            return environments.first(where: { (e) -> Bool in
                return e.active
            })
        }
    }
    //
    enum CodingKeys : String, CodingKey {
        case environments
        case messages
        case services
    }
}

public struct AppCharges:Decodable {
    
    public var linkAccount:String
    public var approveTransfer:String
    public var startSTO:String
    public var amendSTO:String
    
    enum CodingKeys:String,CodingKey{
        case linkAccount = "link-account"
        case approveTransfer = "approve-transfer"
        case startSTO = "start-sto"
        case amendSTO = "amend-sto"
    }
}

public struct AppMessages:Decodable{
   
    public var serviceError:String
    public var connectionError:String
    public var transactionSuccess:String
    public var appUpdates:String
    
    enum CodingKeys:String,CodingKey{
        case serviceError = "service-error"
        case connectionError = "conn-error"
        case transactionSuccess = "trans-success"
        case appUpdates = "app-update"
    }
}
 
 
public struct AppEnvironment:Decodable {
    public var name:String
    public var active:Bool
    public var earlyRelease:Bool
    public var appTimeout:Double
    //
    public var rootURL:String
    public var endPoint:String
    //
    public var IsDevt :Bool {
        get{
            return name.lowercased() == "development"
        }
    }
    // Mark: Computed value
    public var IsEarlyTest:Bool{
        get{
            return !IsDevt && earlyRelease
        }
    }
    
    enum CodingKeys:String,CodingKey{
        case name
        case active
        case earlyRelease = "early-build"
        case rootURL = "base-path"
        case appTimeout = "app-timeout"
        case endPoint = "end-point"
     }
}

public struct AppServices:Decodable{
    
    public var userProfile:String

    
    enum CodingKeys:String,CodingKey{
        case userProfile = "user-profile"
    }
   
    
}

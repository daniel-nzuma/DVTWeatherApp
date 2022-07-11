//
//  WeatherItem.swift
//  DVTWeatherApp
//
//  Created by Daniel Nzuma on 10/07/2022.
//

import Foundation
import UIKit

public class WeatherItem:NSObject,Codable
{
    
    public var middleName:String?
    public var firstName:String?
    public var lastName:String?
     public var registrationNumber:String?
    public var schoolCode:String?
    public var paymentCode:Int?
    
     
    override public init(){
        super.init()
    }
    
    enum CodingKeys: String, CodingKey {
        
        case middleName
        case firstName
        case lastName
        case studentClass
        case mIcon
        case registrationNumber
        case schoolCode
        case paymentCode
   }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
     
        middleName = try? container.decodeIfPresent(String.self, forKey: .middleName)
        firstName = try? container.decodeIfPresent(String.self, forKey: .firstName)
        lastName = try? container.decodeIfPresent(String.self, forKey: .lastName)
         registrationNumber = try? container.decodeIfPresent(String.self, forKey: .registrationNumber)
        schoolCode = try? container.decodeIfPresent(String.self, forKey: .schoolCode)
        paymentCode = try? container.decodeIfPresent(Int.self, forKey: .paymentCode)
        
    }
    
    public  func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(middleName , forKey: .middleName)
        try? container.encode(firstName , forKey: .firstName)
        try? container.encode(lastName , forKey: .lastName)
         try? container.encode(registrationNumber , forKey: .registrationNumber)
        try? container.encode(schoolCode , forKey: .schoolCode)
        try? container.encode(paymentCode , forKey: .paymentCode)
         
    }
    
    public static func fromJson(jsonString: Data?)->WeatherItem{
      
        var mESchoolsBillItem = WeatherItem()
              
              do {
                  
                  if let jsonData = jsonString {
                      mESchoolsBillItem = try JSONDecoder().decode(WeatherItem.self, from: jsonData)
                  }
                
                   } catch {
                       print(error)
                   }
                 
                  return mESchoolsBillItem
     }
}
 

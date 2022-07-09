//
//  AppUtils.swift
//  networkingCore
//
//  Created by Daniel Nzuma on 06/07/2022.
//

import Foundation
import UIKit
import os.log
//

let DATE_FORMAT_0 = "EEE, dd MMM yyyy kk:mm:ss z"
let DATE_FORMAT_1 = "MM/dd/yyyy kk:mm:ss a"
let DATE_FORMAT_2 = "yyyy-MM-dd'T'HH:mm:ss"
let DATE_FORMAT_3 = "yyyy-MM-dd'T'HH:mm:ssZ"
let DATE_FORMAT_4 = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"

public class AppUtils
{
    
    static var TAG:String = "AppUtils : "
    static let log = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "general")
    
    public static var defaultDateFormat : String{
        get{
            return  DATE_FORMAT_3
        }
    }
    
    public class func compareDate(dateInitial:Date, dateFinal:Date) -> Bool {
        let order = Calendar.current.compare(dateInitial, to: dateFinal, toGranularity: .second)
        switch order {
        case .orderedSame:
            return true
        default:
            return false
        }
    }
    //
      
    
    ///
    public class func parseDate(with date : String?, completion: @escaping (Bool,Date) -> Swift.Void) -> Date?{
        //
        guard let date = date else{
            //
            return nil
        }
         AppUtils.Log(from:self,with:AppUtils.TAG+" Date String = \(date)")
        let dateFormatter = DateFormatter()
       // dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = DATE_FORMAT_0
        //dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        var dateFromString:Date?
        //
        if let date = dateFormatter.date(from: date) {
            //AppUtils.Log(from:self,with:MtejaUtils.TAG+"Function 2: SUCCEEDED");
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            let _ = dateFormatter.string(from: date)
            
            AppUtils.Log(from:self,with:AppUtils.TAG+"F1 > Parsed Date = '\(date)' to '\(date.description(with: Locale.current))'")
            completion(true,date)
            //
            dateFromString = date
            //
        }else{
            //dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = DATE_FORMAT_1
            //
            if let date = dateFormatter.date(from: date) {
                //
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                let _ = dateFormatter.string(from: date)
                
                AppUtils.Log(from:self,with:AppUtils.TAG+"F2 > Parsed Date = '\(date)' to '\(date.description(with: Locale.current))'")
                completion(true,date)
                //
                dateFromString = date
            }//
            else{
                //dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                dateFormatter.dateFormat = DATE_FORMAT_2
                //
                if let date = dateFormatter.date(from: date) {
                    //AppUtils.Log(from:self,with:MtejaUtils.TAG+"Function 3:...");
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                    let _ = dateFormatter.string(from: date)
                    
                    AppUtils.Log(from:self,with:AppUtils.TAG+"F3 > Parsed Date = '\(date)' to '\(date.description(with: Locale.current))'")
                    completion(true,date)
                    //
                    dateFromString = date
                }else{
                    //dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                    dateFormatter.dateFormat = DATE_FORMAT_3
                    //
                    if let date = dateFormatter.date(from: date) {
                        //
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                        let _ = dateFormatter.string(from: date)
                        
                        AppUtils.Log(from:self,with:AppUtils.TAG+"F4 > Parsed Date = '\(date)' to '\(date.description(with: Locale.current))'")
                        completion(true,date)
                        //
                        dateFromString = date
                    }else{
                        //dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                        dateFormatter.dateFormat = DATE_FORMAT_4
                        //
                        if let date = dateFormatter.date(from: date) {
                            //
                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                            let _ = dateFormatter.string(from: date)
                            
                            AppUtils.Log(from:self,with:AppUtils.TAG+"F5 > Parsed Date = '\(date)' to '\(date.description(with: Locale.current))'")
                            completion(true,date)
                            //
                            dateFromString = date
                        }else{
                            AppUtils.Log(from:self,with:AppUtils.TAG+"!!!!>>>>>>>>>>>>>>>>>>PARSE DATE FAILED<<<<<<<<<<<!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
                            completion(false,Date())
                        }
                    }
                }

            }
        }
        
        //
        return dateFromString
    }
    
    
    public class func getMaskedString(_ string:String?, prefixedBy:Int, sufixedBy:Int) -> String{
        //
        guard let text = string else{
            //Ooops..
            return ""
        }
        //
        if text.lengthOfBytes(using: .utf8) > (prefixedBy+sufixedBy){
            //
            let startConditionIndex = prefixedBy
            let endConditionIndex = text.count - sufixedBy
            //
            return String(text.enumerated().map { (index, element) -> Character in
                if index <= startConditionIndex {
                   return element
                }
                //
                if index < endConditionIndex {
                    return  "✽"
                }
                return element
            })
        }
        
        return text
    }
    
    public class func getDateString(from date:Date, dateFormatter:DateFormatter) -> String{
        //
        let pars = Calendar.current.dateComponents([.day, .year, .month], from: date)
        //
        
        if pars.year == Calendar.current.dateComponents([.day, .year, .month], from: Date()).year{
            //
            if pars.month == Calendar.current.dateComponents([.day, .year, .month], from: Date()).month{
               dateFormatter.dateFormat = "HH:mm a"
                //
                if pars.day == Calendar.current.dateComponents([.day, .year, .month], from: Date()).day{
                    //
                    return "Today, \(dateFormatter.string(from: date))"
                }else if pars.day == Calendar.current.dateComponents([.day, .year, .month], from: Calendar.current.date(byAdding: .day, value: -1, to: Date())!).day{
                    //
                    return "Yesterday, \(dateFormatter.string(from: date))"
                }
            }
        }
        //
        return dateFormatter.string(from: date)
    }
    
    public class func getTimeGreetingVerb() -> String{
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
            case 0..<12 :
                return(NSLocalizedString("Good Morning", comment: "Morning"))
            case 12 :
                return(NSLocalizedString("Good Afternoon", comment: "Noon"))
            case 13..<17 :
                return(NSLocalizedString("Good Afternoon", comment: "Afternoon"))
            case 17..<22 :
                return(NSLocalizedString("Good Evening", comment: "Evening"))
            default:
                return(NSLocalizedString("Good Day", comment: "Night"))
            //
        }
        //
        //return(NSLocalizedString("Good Day", comment: "Night"))
    }
    
    
//    public static func formatAccountName(with acc:BankAccount) -> String{
//        return "\(AppUtils.getMaskedString(acc.Account,prefixedBy:3,sufixedBy:4)) \(acc.Currency)"
//    }
    
    public static func generateRandomBytes(ofLength:Int) -> String? {
        
        var keyData = Data(count: ofLength)
        let result = keyData.withUnsafeMutableBytes {
            SecRandomCopyBytes(kSecRandomDefault, ofLength, $0.baseAddress!)
        }
        if result == errSecSuccess {
            return keyData.base64EncodedString()
        } else {
            return nil
        }
    }
    
    public static func generateRandomData(ofLength length: Int) throws -> Data? {
        var bytes = [UInt8](repeating: 0, count: length)
        let status = SecRandomCopyBytes(kSecRandomDefault, length, &bytes)
        if status == errSecSuccess {
            return Data(_ : bytes)
        }
        //
        return nil
    }
    
    public static func Log(from obj:AnyObject, with :String){
        //let message = #"String interpolation looks like this: \(with)."#
        if let env = AppConfig.Current?.Environment, env.IsDevt {
            //
            //os_log("\(type(of: obj)) ", log: log, " |:> \(with)")
            debugPrint("\(String(describing: type(of: obj))) |:> \(with)")
        }
        //print("\(String(describing: type(of: obj))) |:> \(with)")
    }
    
    
}

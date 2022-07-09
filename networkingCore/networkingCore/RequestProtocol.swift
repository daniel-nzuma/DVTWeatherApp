//
//  RequestProtocol.swift
//  networkingCore
//
//  Created by Daniel Nzuma on 06/07/2022.
//

import Foundation

protocol RequestProtocol:AnyObject {
    
    func prepareRequest(_ url:URL,_ method:String, _ token:String?) -> URLRequest
    
    func digestResponse(_ data:Data?, _ response:URLResponse?, _ error:Error?, _ config:Config) -> (String?,String?)
}

extension RequestProtocol {
    
    //MARK:- Default behaviour for compose request
    func prepareRequest(_ url:URL,_ method:String, _ token:String?) -> URLRequest {
        
        var r = URLRequest(url: url)
        
        r.httpMethod = method
        r.addValue("application/json",forHTTPHeaderField: "Content-Type")
        r.addValue("application/json",forHTTPHeaderField: "Accept")
        //
        if let t = token {
          r.addValue("Bearer \(t)",forHTTPHeaderField: "Authorization")
        }
        
        return r
    }
    
    //MARK:- Default behaviour for digest Response
    func digestResponse(_ data:Data?, _ response:URLResponse?, _ error:Error?, _ config:Config) -> (String?,String?) {
        //
        guard let data = data, error == nil else {
            // check for fundamental networking error
            return (nil,config.messages.connectionError)
        }
        //
        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
            // check for http errors
            let r = String(data: data, encoding: String.Encoding.utf8)
            AppUtils.Log(from:self,with:"Resp Code = \(httpStatus.statusCode),\n Failure Response: \(String(describing: r)) ")
            //
            do{
                //
                guard let rawDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    //
                    AppUtils.Log(from:self,with:"Error: Couldn't decode Error response data")
                    return (nil,config.messages.serviceError)
                }
                //
                return (nil,rawDict["message"] as? String)
            }catch{
                debugPrint(error)
            }
            return (nil,config.messages.serviceError)
        }
        //
        let responseString = String(data: data, encoding: .utf8)
        AppUtils.Log(from:self,with:"responseString = \(String(describing: responseString))")

        //
        return (responseString,nil)
    }
    
}


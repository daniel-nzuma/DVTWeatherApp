//
//  APIServiceImpl.swift
//  networkingCore
//
//  Created by Daniel Nzuma on 06/07/2022.
//

import Foundation

extension RequestManager:APIServiceProtocol {
    
   
    public func findUser(phone: String, email: String, _ completion: @escaping (Int,Bool?,String?,Bool?, String?) -> Void) {
        
        //
        guard let config = config , let path = config.Environment?.rootURL, let endpoint = config.Environment?.endPoint, let url = URL(string: "\(path)\(endpoint)") else {
            completion(0,nil,nil,nil,"Invalid Service Config.")
            return
        }
        //
        let rdata = PhoneLookupRequest()
        rdata.phone = phone
        rdata.email = email
        rdata.service = "profile"
        rdata.imei = "_"
        //
        var request = prepareRequest(url,"POST",nil)
        //
        let body = String(data:try! JSONEncoder().encode(rdata),encoding: .utf8)!
        //
        request.httpBody = body.data(using: .utf8)
    
        //
        print("HEADERS \n \(request.allHTTPHeaderFields)")
        //
        AppUtils.Log(from: self, with: "Req Body => \(String(decoding: request.httpBody!, as: UTF8.self))")
        
        let task = self.requestsSession.dataTask(with: request) { data, response, error in
            //
            let (r, msg) = self.digestResponse(data, response, error, config)
            //
            guard let responseString = r else {
                // check for fundamental networking error
                completion(0,nil,nil,nil,msg ?? config.messages.connectionError)
                return
            }
            //
            let decoder = JSONDecoder()
            //
            guard let rdata = responseString.data(using: .utf8), let payload = try? decoder.decode(ApiDefaultResponse.self, from: rdata) else {
                AppUtils.Log(from:self,with:"Error: Couldn't decode Dasic Object Resp.")
                completion(0,nil,nil,nil,config.messages.serviceError)
                return
            }
            //
            guard payload.status == 1 else {
                AppUtils.Log(from:self,with:"Error: Server Failed to process req.")
                completion(0,nil,nil,nil,payload.message ?? config.messages.serviceError)
                return
            }
            //Encode
            guard let obj = try? JSONEncoder().encode(payload.data), let raw = String(data: obj, encoding: .utf8) else {
                AppUtils.Log(from:self,with:"Error: Payload Error")
                completion(0,nil,nil,nil,config.messages.serviceError)
                return
            }
            
            //Decode
            guard let resp = try? decoder.decode(PhoneLookupResponse.self, from: raw.data(using: .utf8)!) else {
                //
                completion(0,nil,nil,nil,payload.message ?? config.messages.serviceError)
                return
            }
            
            //
            completion(1, resp.isFirstLogin, resp.otp,resp.enforceOtp,resp.message ?? config.messages.transactionSuccess)
        }
        //
        task.resume()
    }
    
    
    
}

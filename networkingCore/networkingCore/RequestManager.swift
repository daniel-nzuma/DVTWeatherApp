//
//  RequestManager.swift
//  networkingCore
//
//  Created by Daniel Nzuma on 06/07/2022.
//

import Foundation

extension RequestManager: URLSessionDelegate{
    //MARK: Hook SSL Pinning Module
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
        // Let TrustKit handle it
        //TrustKit.sharedInstance().pinningValidator.handle(challenge, completionHandler: completionHandler)
        completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }
}

public class RequestManager:NSObject,RequestProtocol {
    
    var getTokenAttempts = 0
    //Shared Instance
    fileprivate static var _inst:RequestManager? = nil
    //
    public static var AuthInstance:APIServiceProtocol{
        get{
            if _inst == nil {
                _inst = RequestManager()
            }
            return _inst!
        }
        set{}
    }
    
    //
    internal var config:Config?
    //
    internal let dispatchQueue = DispatchQueue(label: "apiservice.queue.dispatcheueuq")
    internal lazy var requestsSession: URLSession = {
        //
        let configuration = URLSessionConfiguration.default
        configuration.tlsMinimumSupportedProtocol = .dtlsProtocol12
        //
        return URLSession(configuration: configuration,
                        delegate: self,
                        delegateQueue: nil)
    }()
    
    override init(){
        super.init()
        config = AppConfig.Current
    }
    
    
}

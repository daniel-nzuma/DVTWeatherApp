//
//  APIServiceImpl.swift
//  networkingCore
//
//  Created by Daniel Nzuma on 06/07/2022.
//

import Foundation

extension RequestManager:APIServiceProtocol {
     
    
     
   
    public func getCurrentWeather(mGetCurrenWeatherReq: GetWeatherRequest, _ completion: @escaping (Int, String?, String?, String?, String?, String) -> Void)
    {
        
        guard
            let rootURL = config?.Environment?.rootURL,
            let currntWeatherEndpoint = config?.Environment?.currentWeatherEndpoint,
            let units = config?.Environment?.units,
            let appID = config?.Environment?.appID,
            let fullURL = URL(string: "\(rootURL)\(currntWeatherEndpoint)")
        else {
            completion(0,nil,nil,nil,"Invalid Service Config.","")
            return
        }

        
        var getCurrentWeatherURLComponent: URLComponents? {

            var urlComponents = URLComponents(string: fullURL.description)
            
            urlComponents?.queryItems = [
                URLQueryItem(name: "lat", value: mGetCurrenWeatherReq.latitude),
                URLQueryItem(name: "lon", value: mGetCurrenWeatherReq.longitude),
                URLQueryItem(name: "appid", value: appID),
                URLQueryItem(name: "units", value: units)

            ]
            return urlComponents
        }
        
          guard
               let config = config ,
               let urlComponents = getCurrentWeatherURLComponent,
               let requestURL = urlComponents.url?.absoluteURL
          else {
              completion(0,nil,nil,nil,"Invalid Service Config.","")
              return
          }
         
         
        let task = self.requestsSession.dataTask(with: requestURL) { data, response, error in
            //
            let (r, msg) = self.digestResponse(data, response, error, config)
            
            //
            guard let responseString = r else {
                // check for fundamental networking error
                completion(0,nil,nil,nil,msg ?? config.messages.connectionError,"")
                return
            }
            //
           
            let decoder = JSONDecoder()
            //Decode
            guard let rdata = responseString.data(using: .utf8),let resp = try? decoder.decode(GetCurrentWeatherResp.self, from: rdata) else {
                //
                completion(1,nil,nil,nil,msg ?? config.messages.connectionError,"")
                return
            }
            
            
            completion(1,resp.mWeatherItem?.currentTemperature?.description,resp.mWeatherItem?.minimumTemperature?.description,resp.mWeatherItem?.maxTemperature?.description,resp.mCurrentWeatherList?[0].name,resp.city!)
 
        }
        //
        task.resume()
    }
    
    public func getWeatherForecast(mGetCurrenWeatherReq: GetWeatherRequest, _ completion: @escaping (Int,[WeatherForecastItem]?,String?) -> Void) {
        
        guard
            let rootURL = config?.Environment?.rootURL,
            let currntWeatherEndpoint = config?.Environment?.weatherForecastEndPoint,
            let units = config?.Environment?.units,
            let appID = config?.Environment?.appID,
            let fullURL = URL(string: "\(rootURL)\(currntWeatherEndpoint)")
        else {
            completion(0,nil,"Invalid Service Config.")
            return
        }

        
        var urlComponents: URLComponents? {

            var urlComponents = URLComponents(string: fullURL.description)
            
            urlComponents?.queryItems = [
                URLQueryItem(name: "lat", value: mGetCurrenWeatherReq.latitude),
                URLQueryItem(name: "lon", value: mGetCurrenWeatherReq.longitude),
                URLQueryItem(name: "appid", value: appID),
                URLQueryItem(name: "units", value: units)

            ]
            return urlComponents
        }
        
          guard
               let config = config ,
               let urlComponents = urlComponents,
               let requestURL = urlComponents.url?.absoluteURL
          else {
              completion(0,nil,"Invalid Service Config.")
              return
          }
         
         
        let task = self.requestsSession.dataTask(with: requestURL) { data, response, error in
            //
            let (r, msg) = self.digestResponse(data, response, error, config)
            
            //
            guard let responseString = r else {
                // check for fundamental networking error
                completion(0,nil,msg ?? config.messages.connectionError)
                return
            }
            //
           
            let decoder = JSONDecoder()
            //Decode
            guard let rdata = responseString.data(using: .utf8),let resp = try? decoder.decode(WeatherForecastResponse.self, from: rdata) else {
                //
                completion(1,nil,msg ?? config.messages.connectionError)
                return
            }
            

            completion(1,resp.mWeatherForecastList,msg)
 
        }
        //
        task.resume()
    }
    
    
    
}

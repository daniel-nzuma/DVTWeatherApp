//
//  APIServiceProtocol.swift
//  networkingCore
//
//  Created by Daniel Nzuma on 06/07/2022.
//

import Foundation

public protocol APIServiceProtocol:AnyObject {
    //
    func getCurrentWeather(mGetCurrenWeatherReq:GetWeatherRequest, _ completion: @escaping (_ status:Int,_ current:String?,_ min:String?,_ max:String?,_ msg:String?) -> Swift.Void) -> Swift.Void
    
    func getWeatherForecast(mGetCurrenWeatherReq:GetWeatherRequest, _ completion: @escaping (_ status:Int,_ data:[WeatherForecastItem]?,_ msg:String?) -> Swift.Void) -> Swift.Void
    
    
}


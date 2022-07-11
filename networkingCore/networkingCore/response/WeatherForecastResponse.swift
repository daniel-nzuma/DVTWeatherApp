//
//  PhoneLookupResponse.swift
//  networkingCore
//
//  Created by Daniel Nzuma on 06/07/2022.
//

import Foundation

class WeatherForecastResponse:NSObject,Codable{
    
    public var mWeatherForecastList:[WeatherForecastItem]?
    
    private enum CodingKeys: String, CodingKey {
        case mWeatherForecastList = "list"
    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mWeatherForecastList = try? container.decodeIfPresent([WeatherForecastItem].self, forKey: .mWeatherForecastList)
    }
    
    public  func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(mWeatherForecastList , forKey: .mWeatherForecastList)

    }
     
}

public class WeatherForecastItem:NSObject,Codable
{
    public var mainWeather:ForecastWeatherItem?
    public var timestmp:String?
    public var mWeatherDesc:[WeatherDesc]?
    
    private enum CodingKeys: String, CodingKey {
        case mainWeather = "main"
        case timestmp = "dt_txt"
        case mWeatherDesc = "weather"
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let h = try container.decodeIfPresent(ForecastWeatherItem.self, forKey: .mainWeather){
            mainWeather = h
        }
        timestmp = try? container.decodeIfPresent(String.self, forKey: .timestmp)
        mWeatherDesc = try? container.decodeIfPresent([WeatherDesc].self, forKey: .mWeatherDesc)

    }
     
}

public class ForecastWeatherItem:NSObject,Codable
{
    public var currentTemperature:Float?
    
    private enum CodingKeys: String, CodingKey {
        case currentTemperature = "temp"
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let h = try container.decodeIfPresent(Float.self, forKey: .currentTemperature){
            currentTemperature = h
        }
    }
     
}

public class WeatherDesc:NSObject,Codable
{
    public var weatherName:String?
    
    private enum CodingKeys: String, CodingKey {
        case weatherName = "main"
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let h = try container.decodeIfPresent(String.self, forKey: .weatherName){
            weatherName = h
        }
    }
     
}

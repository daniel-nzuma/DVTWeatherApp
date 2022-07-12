//
//  PhoneLookupResponse.swift
//  networkingCore
//
//  Created by Daniel Nzuma on 06/07/2022.
//

import Foundation


class GetCurrentWeatherResp:NSObject,Codable{
    
    public var mWeatherItem:WeatherItemResp?
    public var city:String? = ""
    public var mCurrentWeatherList:[CurrentWeather]?

    
    private enum CodingKeys: String, CodingKey {
        case mWeatherItem = "main"
        case city = "name"
        case mCurrentWeatherList = "weather"

    }
    
    required public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mWeatherItem = try? container.decodeIfPresent(WeatherItemResp.self, forKey: .mWeatherItem)
        city = try? container.decodeIfPresent(String.self, forKey: .city)
        mCurrentWeatherList = try? container.decodeIfPresent([CurrentWeather].self, forKey: .mCurrentWeatherList)

    }
    
    public  func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try? container.encode(mWeatherItem , forKey: .mWeatherItem)
        try? container.encode(city , forKey: .city)
        try? container.encode(mCurrentWeatherList , forKey: .mCurrentWeatherList)

    }
     
}

 

public class CurrentWeather:NSObject,Codable
{
    public var name:String?
     
    private enum CodingKeys: String, CodingKey {
        case name = "main"
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try? container.decodeIfPresent(String.self, forKey: .name)
    }
     
}

class WeatherItemResp:NSObject,Codable
{
    public var currentTemperature:Float?
    public var minimumTemperature:Float?
    public var maxTemperature:Float?
    public var feels_like:Float?
    public var humidity:Int = 0
   
    
    private enum CodingKeys: String, CodingKey {
        case currentTemperature = "temp"
        case feels_like
        case humidity
        case minimumTemperature = "temp_min"
        case maxTemperature = "temp_max"
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let h = try container.decodeIfPresent(Float.self, forKey: .currentTemperature){
            currentTemperature = h
        }
        if let h = try container.decodeIfPresent(Float.self, forKey: .feels_like){
            feels_like = h
        }
        if let h = try container.decodeIfPresent(Float.self, forKey: .minimumTemperature){
            minimumTemperature = h
        }
        if let h = try container.decodeIfPresent(Float.self, forKey: .maxTemperature){
            maxTemperature = h
        }
        if let h = try container.decodeIfPresent(Int.self, forKey: .humidity){
            humidity = h
        }
    }
     
}

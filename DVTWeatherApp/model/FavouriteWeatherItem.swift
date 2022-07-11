//
//  PhoneLookupRequest.swift
//  networkingCore
//
//  Created by Daniel Nzuma on 06/07/2022.
//

import Foundation

public struct FavouriteWeatherItem {
    
    var country: String?
    var city: String?
    var lat:String?
    var long:String?
    
    init(country: String?, city: String?,lat:String?,long:String?) {
      
        self.country = country
        self.city = city
        self.lat = lat
        self.long = long

    }

}

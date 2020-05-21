//
//  Sys.swift
//  Weather App
//
//  Created by Karrar Abd Ali on 21/05/2020.
//  Copyright © 2020 Karrar Abd Ali. All rights reserved.
//

import Foundation

class Sys {
    var type : Int
    var id: Int
    var message: Double
    var country: String
    var sunrise: Int
    var sunset: Int
    
    init(type : Int, id: Int,  message: Double, country: String,  sunrise: Int,  sunset: Int) {
        self.type = type
        self.id = id
        self.message = message
        self.country = country
        self.sunrise = sunrise
        self.sunset = sunset
    }
}

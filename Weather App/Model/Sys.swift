//
//  Sys.swift
//  Weather App
//
//  Created by Karrar Abd Ali on 21/05/2020.
//  Copyright © 2020 Karrar Abd Ali. All rights reserved.
//

import Foundation

class Sys: Decodable {
    let type, id: Int
    let country: String
    let sunrise, sunset: Int
    var message: Double?
    
    init(type : Int, id: Int, country: String,  sunrise: Int,  sunset: Int, message: Double? = nil) {
        self.type = type
        self.id = id
        self.country = country
        self.sunrise = sunrise
        self.sunset = sunset
        self.message = message
    }
}

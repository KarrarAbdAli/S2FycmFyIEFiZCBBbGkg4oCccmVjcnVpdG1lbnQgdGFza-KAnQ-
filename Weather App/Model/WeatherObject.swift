//
//  WeatherObject.swift
//  Weather App
//
//  Created by Karrar Abd Ali on 21/05/2020.
//  Copyright © 2020 Karrar Abd Ali. All rights reserved.
//

import Foundation

class WeatherObject: Decodable{
    var coord: Coord?
    var weather: [Weather]?
    var base: String?
    var main: Main?
    var visibility: Int?
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone, id: Int
    let name: String
    let cod: Int
    
    
    init(base: String?, visibility: Int?,  dt: Int, id: Int, name: String, cod: Int, coord: Coord?, weather: [Weather]?, main: Main?, clouds: Clouds, sys: Sys, wind: Wind, timezone: Int) {
        self.base = base
        self.visibility = visibility
        self.dt = dt
        self.name = name
        self.id = id
        self.cod = cod
        
        self.coord = coord
        self.weather = weather
        self.main = main
        self.clouds = clouds
        self.sys = sys
        self.wind = wind
        self.timezone = timezone
    }
}

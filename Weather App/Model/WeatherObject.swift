//
//  WeatherObject.swift
//  Weather App
//
//  Created by Karrar Abd Ali on 21/05/2020.
//  Copyright © 2020 Karrar Abd Ali. All rights reserved.
//

import Foundation

class WeatherObject {
    var base: String
    var visibility: Int
    var dt: Int
    var id: Int
    var name: String
    var cod: Int
    
    var coord: Coord
    var weather: [Weather]
    var main: Main
    var clouds: Clouds
    var sys: Sys
    
    init(base: String, visibility: Int,  dt: Int, id: Int, name: String, cod: Int, coord: Coord, weather: [Weather], main: Main, clouds: Clouds, sys: Sys) {
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
        
    }
}

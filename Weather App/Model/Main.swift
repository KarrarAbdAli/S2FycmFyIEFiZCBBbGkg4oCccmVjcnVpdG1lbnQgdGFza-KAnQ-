//
//  Main.swift
//  Weather App
//
//  Created by Karrar Abd Ali on 21/05/2020.
//  Copyright © 2020 Karrar Abd Ali. All rights reserved.
//

import Foundation
class Main: Decodable {
    let temp: Double
    let pressure, humidity: Int
    let tempMin, tempMax: Double

    enum CodingKeys: String, CodingKey {
        case temp, pressure, humidity
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
    
    init(temp: Double, pressure: Int, humidity: Int, temp_min: Double,  temp_max: Double) {
        self.temp = temp
        self.pressure = pressure
        self.humidity = humidity
        self.tempMin = temp_min
        self.tempMax = temp_max
    }
}

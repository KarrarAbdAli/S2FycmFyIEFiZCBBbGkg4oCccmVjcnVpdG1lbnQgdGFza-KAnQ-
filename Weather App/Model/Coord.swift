//
//  Coord.swift
//  Weather App
//
//  Created by Karrar Abd Ali on 21/05/2020.
//  Copyright © 2020 Karrar Abd Ali. All rights reserved.
//

import Foundation
class Coord: Decodable {
    let lon, lat: Double
    
    init(lon: Double, lat: Double) {
        self.lon = lon
        self.lat = lat
    }
}

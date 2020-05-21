//
//  Weather.swift
//  Weather App
//
//  Created by Karrar Abd Ali on 21/05/2020.
//  Copyright © 2020 Karrar Abd Ali. All rights reserved.
//

import Foundation
class Weather: Decodable {
   let id: Int
    let main, weatherDescription, icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
    
    init(id: Int, main: String, description: String, icon: String){
        self.id = id
        self.main = main
        self.weatherDescription = description
        self.icon = icon
    }
}

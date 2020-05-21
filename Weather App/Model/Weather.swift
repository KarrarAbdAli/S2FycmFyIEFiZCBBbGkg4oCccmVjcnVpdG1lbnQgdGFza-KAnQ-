//
//  Weather.swift
//  Weather App
//
//  Created by Karrar Abd Ali on 21/05/2020.
//  Copyright © 2020 Karrar Abd Ali. All rights reserved.
//

import Foundation
class Weather {
    var id: Int
    var main: String
    var description: String
    var icon: String
    
    init(id: Int, main: String, description: String, icon: String){
        self.id = id
        self.main = main
        self.description = description
        self.icon = icon
    }
}

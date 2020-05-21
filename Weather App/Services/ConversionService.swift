//
//  ConversionService.swift
//  Weather App
//
//  Created by Karrar Abd Ali on 21/05/2020.
//  Copyright © 2020 Karrar Abd Ali. All rights reserved.
//

import Foundation
class ConversionService {
    static func getTempretureInC(_ kelvenValue: Double) -> Int {
        Int((kelvenValue - 273.15))
    }
    
    static func getTempretureInF(_ kelvenValue: Double) -> Int {
        Int(((kelvenValue - 273.15) * 9/5) + 32)
    }
}

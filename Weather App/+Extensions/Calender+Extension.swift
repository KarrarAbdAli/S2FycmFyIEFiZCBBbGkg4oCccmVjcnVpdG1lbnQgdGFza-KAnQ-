//
//  Calender+Extension.swift
//  Weather App
//
//  Created by Karrar Abd Ali on 22/05/2020.
//  Copyright © 2020 Karrar Abd Ali. All rights reserved.
//

import Foundation

extension Calendar {
    func getTimeFromCalender(date: Date) -> String {
        let hour = self.component(.hour, from: date)
        let minutes = self.component(.minute, from: date)
        let seconds = self.component(.second, from: date)
        return "\(hour):\(minutes):\(seconds)"
    }
}

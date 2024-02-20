//
//  Date+Ext.swift
//  WeatherForecast2
//
//  Created by Admin on 19/02/2024.
//

import Foundation

extension Date {
    func formattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE dd MMMM"
        return dateFormatter.string(from: self)
    }
}

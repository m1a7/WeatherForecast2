//
//  ForecastItem.swift
//  WeatherForecast
//
//  Created by Admin on 17/02/2024.
//

import Foundation

struct ForecastItem: Identifiable {
    let id = UUID()
    let temp: Int
    let pressure: Int
    let date: Date
    var title: String = ""
    var icon: String = ""

    enum RootKeys: String, CodingKey {
        case main, weather, date = "dt"
    }
    enum MainForecastKeys: String, CodingKey {
        case temp, pressure
    }
    enum WeatherKeys: String, CodingKey {
        case main, icon
    }
}

extension ForecastItem: Decodable {

    init(from decoder: Decoder) throws {
        // RootContainer
        let rootContainer = try decoder.container(keyedBy: RootKeys.self)
        let timestamp = try rootContainer.decode(TimeInterval.self, forKey: .date)
        date = Date(timeIntervalSince1970: timestamp)

        // MainContainer
        let mainContainer = try rootContainer.nestedContainer(keyedBy: MainForecastKeys.self, forKey: .main)
        temp = try Int(mainContainer.decode(Double.self, forKey: .temp).rounded())
        pressure = try mainContainer.decode(Int.self, forKey: .pressure)

        // WeatherContainer
        var weatherContainer = try rootContainer.nestedUnkeyedContainer(forKey: .weather)
        if !weatherContainer.isAtEnd {
            let singleWeatherContainer = try weatherContainer.nestedContainer(keyedBy: WeatherKeys.self)
            title = try singleWeatherContainer.decode(String.self, forKey: .main)
            icon = try singleWeatherContainer.decode(String.self, forKey: .icon)
        }
    }
}

extension ForecastItem: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: RootKeys.self)
        var mainContainer = container.nestedContainer(keyedBy: MainForecastKeys.self, forKey: .main)

        try mainContainer.encode(temp, forKey: .temp)
        try mainContainer.encode(pressure, forKey: .pressure)

        var weatherContainer = container.nestedContainer(keyedBy: WeatherKeys.self, forKey: .weather)
        try weatherContainer.encode(title, forKey: .main)
        try weatherContainer.encode(icon, forKey: .icon)
    }
}

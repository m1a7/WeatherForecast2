//
//  WeatherForecast.swift
//  WeatherForecast
//
//  Created by Admin on 17/02/2024.
//

import Foundation

struct WeatherForecast {
    let list: [ForecastItem]
    let city: String

    enum RootKeys: String, CodingKey {
        case list
        case city
    }
    enum CityKeys: String, CodingKey {
        case name
    }
}

extension WeatherForecast: Decodable {
    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: RootKeys.self)
        list = try rootContainer.decode([ForecastItem].self, forKey: .list)

        let cityContainer = try rootContainer.nestedContainer(keyedBy: CityKeys.self, forKey: .city)
        city = try cityContainer.decode(String.self, forKey: .name)
    }
}

extension WeatherForecast: Encodable {
    func encode(to encoder: Encoder) throws {
        var rootContainer = encoder.container(keyedBy: RootKeys.self)
        try rootContainer.encode(list, forKey: .list)

        var cityContainer = rootContainer.nestedContainer(keyedBy: CityKeys.self, forKey: .city)
        try cityContainer.encode(city, forKey: .name)
    }
}

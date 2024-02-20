//
//  ForecastService.swift
//  WeatherForecast2
//
//  Created by Admin on 19/02/2024.
//

import Foundation

enum ForecastService: ServiceProtocol {
    case getForecast(city: String, forDays: Int)
    case image(code: String)
    
    var baseUrl: URL {
        switch self {
            case .image:
                URL(string: Endpoint.imageUrl)!
            default:
                URL(string: Endpoint.baseUrl)!
        }
    }

    var path: String {
        switch self {
        case .getForecast(_, _):
            return "/forecast"
        case .image(let code):
            return "\(code)@2x.png"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getForecast, .image:
            return .get
        }
    }

    var queryItems: QueryItems? {
        switch self {
            case .getForecast(let city, let days):
                return ["q" : city, "cnt" : "\(days)", "appid": AppConstants.apiKey, "units": AppConstants.measurementSystem]
            case .image:
                return [:]
        }
    }
}

//
//  NetworkError.swift
//  WeatherForecast2
//
//  Created by Admin on 19/02/2024.
//

import Foundation

enum NetworkError: Error {
    case noData
    case invalidResponse
    case requestFailed

    var localizedDescription: String {
        switch self {
        case .noData:
            return "No data received"
        case .invalidResponse:
            return "Invalid response received"
        case .requestFailed:
            return "Request failed"
        }
    }
}

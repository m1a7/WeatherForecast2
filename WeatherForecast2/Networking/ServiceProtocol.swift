//
//  ServiceProtocol.swift
//  WeatherForecast2
//
//  Created by Admin on 19/02/2024.
//

import Foundation

public typealias QueryItems = [String: String]

public protocol ServiceProtocol {
    var baseUrl: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: QueryItems? { get }
}

extension ServiceProtocol {
    var queryItems: QueryItems? {
        ["appid": AppConstants.apiKey]
    }
}

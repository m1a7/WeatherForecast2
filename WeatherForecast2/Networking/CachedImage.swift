//
//  CachedImage.swift
//  WeatherForecast2
//
//  Created by Admin on 19/02/2024.
//

import UIKit

class CachedImage {
    let image: UIImage
    let expirationDate: Date

    var isExpired: Bool {
        return expirationDate.compare(Date()) == .orderedAscending
    }
    
    init(image: UIImage, expirationDate: Date) {
        self.image = image
        self.expirationDate = expirationDate
    }
}

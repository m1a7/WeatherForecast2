//
//  WeatherIcon.swift
//  WeatherForecast2
//
//  Created by Admin on 23/02/2024.
//

import SwiftUI

struct WeatherIcon: View {
    let image: UIImage
    let imageSize: CGSize
    
    init(image: UIImage, imageSize: CGSize) {
        self.image = image
        self.imageSize = imageSize
    }
    
    var body: some View {
        Image(uiImage: image)
            .weatherIconModifier(imageSize: imageSize)
    }
}

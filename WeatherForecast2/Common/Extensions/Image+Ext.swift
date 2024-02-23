//
//  Image+Ext.swift
//  WeatherForecast2
//
//  Created by Admin on 23/02/2024.
//

import UIKit
import SwiftUI

extension Image {
    func weatherIconModifier(imageSize: CGSize) -> some View {
        self
            .resizable()
            .aspectRatio(1.0, contentMode: .fit)
            .frame(width: imageSize.width, height: imageSize.height)
    }
}

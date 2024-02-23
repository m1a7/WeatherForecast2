//
//  DetailView.swift
//  WeatherForecast2
//
//  Created by Admin on 19/02/2024.
//

import SwiftUI

struct DetailView: View {
   
    private enum Constants {
        static let temperatureTitle = "Temperature"
        static let pressureTitle = "Pressure"
        static let dateTitle = "Date"
        static let navigationTitle = "Weather Forecast"
        static let loadingTitle = "Loading..."
        static let imageSize = CGSize(width: 100, height: 100)
    }

    @EnvironmentObject var imageDownloader: ImageDownloader
    @State private var downloadedImage: UIImage?
    
    var forecastItem: ForecastItem
    
    var body: some View {
        VStack {
            if let image = downloadedImage {
                WeatherIcon(image: image, imageSize: Constants.imageSize)
            } else {
                Image(systemName: "photo.fill")
                    .weatherIconModifier(imageSize: Constants.imageSize)
                    .onAppear {
                        downloadImage()
                    }
            }
            
            Text("\(Constants.temperatureTitle): \(forecastItem.temp)°C")
                .padding()
            Text("\(Constants.pressureTitle): \(forecastItem.pressure) hPa")
                .padding()
            Text("\(Constants.dateTitle): \(forecastItem.date.formattedDate())")
                .padding()
            Spacer()
        }
    }
    
    private func downloadImage() {
        let imageService = ForecastService.image(code: forecastItem.icon)
        let imgURL = imageService.baseUrl.appendingPathComponent(imageService.path).absoluteString
        imageDownloader.downloadImage(from: imgURL) { image in
            DispatchQueue.main.async {
                downloadedImage = image
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleForecastItem = ForecastItem(temp: 25, pressure: 1015, date: Date(), title: "Sample Title", icon: "sun.max.fill")
        DetailView(forecastItem: sampleForecastItem)
    }
}

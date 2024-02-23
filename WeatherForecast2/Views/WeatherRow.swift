//
//  WeatherRow.swift
//  WeatherForecast2
//
//  Created by Admin on 19/02/2024.
//

import SwiftUI
import Combine

struct WeatherRow: View {
    
    private enum Constants {
        static let imageSize = CGSize(width: 50, height: 50)
    }
    
    @EnvironmentObject var imageDownloader: ImageDownloader
    @State private var downloadedImage: UIImage?
    @State private var cancellable: AnyCancellable?
    
    let item: ForecastItem
    
    init(item: ForecastItem) {
        self.item = item
    }
    
    var body: some View {
        HStack(content: {
            if let image = downloadedImage {
                WeatherIcon(image: image, imageSize: Constants.imageSize)
            } else {
                Image(systemName: "photo.fill")
                    .weatherIconModifier(imageSize: Constants.imageSize)
                    .onAppear {
                        obtainImage()
                    }
                    .onDisappear {
                        cancellable?.cancel()
                    }
            }
            VStack(alignment: .leading) {
                Text(item.date.formattedDate())
                Text("\(item.temp)°C | \(item.title)")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
        })
    }
    
    // none-combine function
    private func downloadImage() {
        let imageService = ForecastService.image(code: item.icon)
        let imgURL = imageService.baseUrl.appendingPathComponent(imageService.path).absoluteString
        imageDownloader.downloadImage(from: imgURL) { image in
            DispatchQueue.main.async {
                downloadedImage = image
            }
        }
    }
    
    // combine function
    private func obtainImage() {
        let imageService = ForecastService.image(code: item.icon)
        let imgURL = imageService.baseUrl.appendingPathComponent(imageService.path).absoluteString
        
        cancellable = imageDownloader.loadImage(from: imgURL)
            .sink(receiveValue: { image in
                downloadedImage = image
            })
    }
    
    private func setDownloadedImage(img: UIImage?) {
        downloadedImage = img
    }
}

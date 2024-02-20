//
//  WeatherRow.swift
//  WeatherForecast2
//
//  Created by Admin on 19/02/2024.
//

import SwiftUI

struct WeatherRow: View {
   
    private enum Constants {
        static let imageSize = CGSize(width: 50, height: 50)
    }
    
    @EnvironmentObject var imageDownloader: ImageDownloader
    @State private var downloadedImage: UIImage?
    
    let item: ForecastItem
    
    var body: some View {
        HStack(content: {
            if let image = downloadedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: Constants.imageSize.width, height: Constants.imageSize.height)
            } else {
                Image(systemName: "photo.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: Constants.imageSize.width, height: Constants.imageSize.height)
                    .onAppear {
                        downloadImage()
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
    
    private func downloadImage() {
        let imageService = ForecastService.image(code: item.icon)
        let imgURL = imageService.baseUrl.appendingPathComponent(imageService.path).absoluteString
        imageDownloader.downloadImage(from: imgURL) { image in
            DispatchQueue.main.async {
                downloadedImage = image
            }
        }
    }
}

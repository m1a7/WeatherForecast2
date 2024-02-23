//
//  ImageDownloader.swift
//  WeatherForecast2
//
//  Created by Admin on 19/02/2024.
//

import UIKit
import Combine

class ImageDownloader: ObservableObject {

    static let shared = ImageDownloader()

    private var imageCache = NSCache<NSString, CachedImage>()

    // Combine function
    func loadImage(from url: String) -> AnyPublisher<UIImage?, Never> {
        guard let url = URL(string: url) else {
            return Just(nil)
                .setFailureType(to: Never.self)
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .compactMap { UIImage(data: $0) }
            .handleEvents(receiveOutput: { image in
                guard let image = image else { return }
                let expirationDate = Date(timeIntervalSinceNow: 24 * 60 * 60)
                let cachedImage = CachedImage(image: image, expirationDate: expirationDate)
                self.imageCache.setObject(cachedImage, forKey: url.absoluteString as NSString)
            })
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
    
    // none-combine fuction
    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        // Check if the image is already in the cache and not expired
        if let cachedImage = imageCache.object(forKey: urlString as NSString),
           !cachedImage.isExpired {
            completion(cachedImage.image)
            return
        }

        // If not in cache or expired, start downloading
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data, error == nil else {
                    completion(nil)
                    return
                }

                if let image = UIImage(data: data) {
                    // Cache the downloaded image with timestamp
                    let expirationDate = Date(timeIntervalSinceNow: 24 * 60 * 60) // One day
                    let cachedImage = CachedImage(image: image, expirationDate: expirationDate)
                    self.imageCache.setObject(cachedImage, forKey: urlString as NSString)
                    completion(image)
                } else {
                    completion(nil)
                }
            }

            task.resume()
        } else {
            completion(nil)
        }
    }
}


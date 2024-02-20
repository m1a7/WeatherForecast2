//
//  APIManager.swift
//  WeatherForecast2
//
//  Created by Admin on 19/02/2024.
//

import Foundation

final class APIManager: ObservableObject {
    static let shared = APIManager()
    private let cacheKey = "cachedPosts"
    
    private weak var task: URLSessionDataTask?
    
    func get<T: Decodable>(for type: T.Type = T.self,
                           service: ServiceProtocol,
                           reloadIgnoringLocalCacheData: Bool = true,
                           completion: @escaping (Result<T, Error>) -> Void) {
        let request = makeRequest(service: service, reloadIgnoringLocalCacheData: reloadIgnoringLocalCacheData)
        
        executeDataTask(with: request, completion: completion)
    }
    
    private func makeRequest(service: ServiceProtocol, reloadIgnoringLocalCacheData: Bool) -> URLRequest {
        let url = service.baseUrl.appendingPathComponent(service.path)
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        
        let queryItems = service.queryItems?.map { URLQueryItem(name: $0, value: $1) } ?? []
        components?.queryItems = queryItems
        
        guard let url = components?.url else {
            fatalError("Invalid URL")
        }
        
        var request = URLRequest(url: url)
        if reloadIgnoringLocalCacheData {
            request.cachePolicy = .reloadIgnoringLocalCacheData
        } else {
            request.cachePolicy = .returnCacheDataElseLoad
        }
        
        request.setValue("request-language", forHTTPHeaderField: "pl")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("text/plain", forHTTPHeaderField: "Accept")
        request.httpMethod = service.method.rawValue
        
        return request
    }
    
    private func executeDataTask<T: Decodable>(with request: URLRequest,
                                               completion: @escaping (Result<T, Error>) -> Void) {
        
        let cache = URLCache.shared
        
        if let cachedData = cache.cachedResponse(for: request)?.data,
           let cachedDTO = try? JSONDecoder().decode(T.self, from: cachedData) {
            // Return cached data if available
            DispatchQueue.main.async {
                completion(.success(cachedDTO))
            }
        } else {
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    let errorMessage = error.map { "\($0)" } ?? "no data"
                    print("❌ executeDataTask error: \(errorMessage)")
                    completion(.failure(error ?? NetworkError.noData))
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let model = try decoder.decode(T.self, from: data)
                    
                    // Cache the fetched data with a maximum age of 1 day (86400 seconds)
                    let cachedResponse = CachedURLResponse(response: response!, data: data)
                    // URLCache will automatically handle caching with a maximum age of 1 day (86400 seconds).
                    cache.storeCachedResponse(cachedResponse, for: request)
                    
                    completion(.success(model))
                } catch let decodingError {
                    completion(.failure(decodingError))
                }
            }
            task.resume()
            self.task = task
        }
    }
}

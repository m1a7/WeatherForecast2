//
//  HomeView.swift
//  WeatherForecast2
//
//  Created by Admin on 19/02/2024.
//

import SwiftUI

struct HomeView: View {

    private enum Constants {
        static let city = "Paris"
        static let numberOfTimestamps = 40
        static let cityTitle = "City"
        static let navigationTitle = "Weather Forecast"
        static let loadingTitle = "Loading..."
    }

    @EnvironmentObject var api: APIManager
    @State private var weatherForecast: WeatherForecast?
    
    var body: some View {
        NavigationView {
            VStack {
                if let weather = weatherForecast {
                    Text("\(Constants.cityTitle): \(weather.city)")
                        .font(.headline)
                        .padding()

                    List(weather.list) { item in
                        NavigationLink(destination: DetailView(forecastItem: item)) {
                            WeatherRow(item: item)
                        }
                    }
                    .listStyle(GroupedListStyle())
                } else {
                    Text(Constants.loadingTitle)
                        .padding()
                }
            }
            .navigationTitle(Constants.navigationTitle)
            .onAppear {
                fetchWeatherForecast()
            }
        }
    }
    
    private func fetchWeatherForecast() {
        let city = Constants.city
        let service = ForecastService.getForecast(city: city, forDays: Constants.numberOfTimestamps)
        api.get(for: WeatherForecast.self, service: service, reloadIgnoringLocalCacheData: false) { result in
            switch result {
                case .success(let response):
                    let filteredList = HomeView.filterForecastForDays(forecastItems: response.list)
                    self.weatherForecast = WeatherForecast(list: filteredList, city: city)
                    
                case .failure(let error):
                    print("❌ Error fetching weather: \(error)")
            }
        }
    }
    
    private static func filterForecastForDays(forecastItems: [ForecastItem]) -> [ForecastItem] {
        // Dictionary to track encountered dates
        var uniqueDates = [Date: Bool]()
        
        // Filter the array, keeping only one object for each unique date
        let forecastItems = forecastItems.filter { forecastItem in
            let startOfDay = Calendar.current.startOfDay(for: forecastItem.date)
            
            // If the date has not been encountered yet, add it to the dictionary and keep the object
            if uniqueDates[startOfDay] == nil {
                uniqueDates[startOfDay] = true
                return true
            } else {
                return false
            }
        }
        return forecastItems
    }
}

#Preview {
    HomeView()
}

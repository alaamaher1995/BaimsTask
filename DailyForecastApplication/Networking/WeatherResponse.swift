//
//  WeatherResponse.swift
//  DailyForecastApplication
//
//  Created by New User on 19/09/2024.
//

import Foundation

struct WeatherResponse: Codable {
    let list: [WeatherEntry]
}

struct WeatherEntry: Codable {
    let dt: Int
    let weather: [Weather]
    let main: WeatherMain
}

struct Weather: Codable {
    let main: String
    let description: String
}

struct WeatherMain: Codable {
    let temp: Double
}

class WeatherAPIClient {
    private let apiKey = "8ddb32088270dd4661e6527082d88db3" //my key from my account alaa maher
    
    func fetchWeather(for latitude: Double, longitude: Double, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                completion(.success(weatherResponse))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}

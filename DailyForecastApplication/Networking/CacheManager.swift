//
//  CacheManager.swift
//  DailyForecastApplication
//
//  Created by New User on 19/09/2024.
//

import Foundation

class CacheManager {
    static let shared = CacheManager()
    
    private init() {}
    
    func saveWeatherData(_ data: Data, forCity city: String) {
        UserDefaults.standard.set(data, forKey: city)
    }
    
    func loadWeatherData(forCity city: String) -> Data? {
        return UserDefaults.standard.data(forKey: city)
    }
}

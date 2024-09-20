//
//  CityManager.swift
//  DailyForecastApplication
//
//  Created by New User on 19/09/2024.
//

import Foundation
class CityManager {
    static let shared = CityManager()
    
    private init() {}
    
    func loadCities(completion: @escaping ([City]) -> Void) {
        guard let path = Bundle.main.path(forResource: "cities", ofType: "json") else {
            print("City JSON file not found")
            return
        }
        
        let url = URL(fileURLWithPath: path)
        
        do {
             let data = try Data(contentsOf: url)
             let cities = try JSONDecoder().decode(CityModel.self, from: data)
            completion(cities.cities)
           
        } catch {
            print("Error loading or parsing JSON: \(error)")
        }
    }
    
  
}

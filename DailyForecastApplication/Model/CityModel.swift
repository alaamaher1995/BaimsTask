//
//  CityModel.swift
//  DailyForecastApplication
//
//  Created by New User on 18/09/2024.
//

import Foundation

struct CityModel:Codable{
    let cities:[City]
}

struct City:Codable{
    let id:Int
    let cityNameAr,cityNameEn : String
    let lat,lon:Double
}

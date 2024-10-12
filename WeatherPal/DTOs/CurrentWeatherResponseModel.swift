//
//  CurrentWeatherResponseModel.swift
//  WeatherPal
//
//  Created by Gehad V on 11/10/2024.
//

import Foundation

struct WeatherResponseModel: Decodable {
    let location: Location
    let current: CurrentWeather
    let forecast: Forecast
}
 
struct Location: Codable {
    var name: String?
    var region: String?
    var country: String?
    var localTime: String?
}

struct CurrentWeather: Codable {
    var temp_c: Float?
    var condition: Condition?
    var wind_mph: Float?
    var humidity: Float?
}


struct Forecast: Codable {
    var forecastday: [ForecastDay]
}


struct ForecastDay: Codable {
    var date: String?
    var day: Day?
}

struct Condition: Codable {
    var text: String?
    var icon: String?
}

struct Day: Codable {
    var maxtemp_c: Float?
    var mintemp_c: Float?
    var condition: Condition?
}

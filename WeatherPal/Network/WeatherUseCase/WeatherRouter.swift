//
//  WeatherRouter.swift
//  WeatherPal
//
//  Created by Gehad V on 11/10/2024.
//

import Foundation

protocol Routable {
    var path: String {get}
    var queryItems: [URLQueryItem]? {get}
    var httpMethod: String {get}
}

enum WeatherParams {
    case byCity(name:String, token: String)
    
    func queryItems() -> [URLQueryItem] {
        switch self {
        case .byCity(let name, let token):
            let cityParam = URLQueryItem(name: "q", value: name)
            let tokenParam = URLQueryItem(name: "key", value: token)
            let daysParam = URLQueryItem(name: "days", value: Constants.weatherDaysCount)
            return [cityParam,tokenParam,daysParam ]
        }
    }
}

enum WeatherRouter: Routable, Decodable {
    
    case currentWeather(cityName: String, token: String)
    
    var path: String {
        switch self {
        case .currentWeather:
            return Constants.NetworkBaseUrl
      
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .currentWeather(let city, let token):
            return WeatherParams.byCity(name: city, token: token).queryItems()
           
        }
    }
    
    var httpMethod: String {
        switch self {
        default:
            return "GET"
        }
    }
    
}

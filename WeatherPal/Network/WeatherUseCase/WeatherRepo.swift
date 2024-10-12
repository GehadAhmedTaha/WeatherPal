//
//  WeatherRepo.swift
//  WeatherPal
//
//  Created by Gehad V on 11/10/2024.
//

import Foundation

protocol WeatherRepoProtocol {
    func getCurrentWeather(cityName: String, completion: @escaping (WeatherResponseModel?) -> Void)
}

class WeatherRepo: WeatherRepoProtocol {
    
    private lazy var store = WeatherStore()
    
    func getCurrentWeather(cityName: String, completion: @escaping (WeatherResponseModel?) -> Void) {
        
        let router = WeatherRouter.currentWeather(cityName: cityName, token: "f0ed405208754b88809130319241110")
        store.getCurrentWeather(router: router) { response in
            guard let weatherResponse = response else {completion(nil);return}
            completion(weatherResponse)
        }
    }
}

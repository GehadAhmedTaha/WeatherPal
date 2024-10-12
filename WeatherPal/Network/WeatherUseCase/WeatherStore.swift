//
//  WeatherStore.swift
//  WeatherPal
//
//  Created by Gehad V on 11/10/2024.
//

import Foundation

protocol WeatherStoreProtocol {
    func getCurrentWeather(router: WeatherRouter, completion: @escaping (WeatherResponseModel?) -> Void)

}

class WeatherStore: WeatherStoreProtocol {
    
    func getCurrentWeather(router: WeatherRouter, completion: @escaping (WeatherResponseModel?) -> Void) {
        
        BaseNetworkManager.shared.request(router: router) { (result: Result<WeatherResponseModel, Error>) in
            switch result {
            case .success(let response):
                completion(response)
            case .failure(_):
                completion(nil)
            }
         }
    }
}

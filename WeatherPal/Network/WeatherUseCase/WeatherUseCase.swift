//
//  WeatherUseCase.swift
//  WeatherPal
//
//  Created by Gehad V on 11/10/2024.
//

import Foundation

protocol WeatherUseCaseProtocol {
    func getCurrentWeather(cityName: String, completion: @escaping (WeatherResponseModel?) -> Void)
}

class WeatherUseCase: WeatherUseCaseProtocol {
    
    let repo: WeatherRepoProtocol
    
    init(repo: WeatherRepo) {
        self.repo = repo
    }
    
    func getCurrentWeather(cityName: String, completion: @escaping (WeatherResponseModel?) -> Void) {
        repo.getCurrentWeather(cityName: cityName) { result in
            completion(result)
        }
    }
    
}

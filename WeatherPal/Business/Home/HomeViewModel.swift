//
//  HomeViewModel.swift
//  WeatherPal
//
//  Created by Gehad V on 12/10/2024.
//

import Foundation
import RxSwift

enum DisplayMode {
    case currentWeather
    case multipleDaysWeather
}
protocol HomeViewModelProtocol {
    var reloadCurrentWeatherSubject: PublishSubject<Bool> { get  }
    var reloadCompleteWeatherSubject: PublishSubject<Bool>  {get  }
    var noDataFoundSubject: PublishSubject<Bool> {get}

    var mode: DisplayMode {get set}
    var currentWeatherData: CurrentWeather?  {get}
    var multipleDaysForecastData :  [ForecastDay]? {get}
    var locationDetails: Location? {get}
    func getWeatherData(for city: String)
}

class HomeViewModel: HomeViewModelProtocol {
    private let useCase = WeatherUseCase(repo: WeatherRepo())
    
    var data: WeatherResponseModel? = nil
    
    var reloadCurrentWeatherSubject: PublishSubject<Bool> = PublishSubject()
    var reloadCompleteWeatherSubject: PublishSubject<Bool> = PublishSubject()
    var noDataFoundSubject: PublishSubject<Bool> = PublishSubject()

    var mode: DisplayMode = .currentWeather
    
    var currentWeatherData: CurrentWeather? {
        return data?.current
    }
    
    var multipleDaysForecastData :  [ForecastDay]? {
        return data?.forecast.forecastday
    }

    var locationDetails: Location? {
        return data?.location
    }
    
    func getWeatherData(for city: String) {
        useCase.getCurrentWeather(cityName: city) { [weak self] response in
            guard let weatherResponse = response else {
                self?.noDataFoundSubject.onNext(true)
                return
            }
            
            self?.data = weatherResponse
            switch self?.mode {
            case .currentWeather:
                self?.reloadCurrentWeatherSubject.onNext(true)

            case .multipleDaysWeather:
                self?.reloadCompleteWeatherSubject.onNext(true)
                
            case .none:
                break
            }
            

        }
    }
}

//
//  ViewController.swift
//  WeatherPal
//
//  Created by Gehad V on 12/10/2024.
//

import UIKit

class HomeViewController: UIViewController {

    let useCase = WeatherUseCase(repo: WeatherRepo())
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        useCase.getCurrentWeather(cityName: "London") { result in
            print(result)
        }
    }
}


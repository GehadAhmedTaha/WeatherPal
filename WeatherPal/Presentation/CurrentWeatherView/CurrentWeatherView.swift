//
//  CurrentWeatherView.swift
//  WeatherPal
//
//  Created by Gehad V on 12/10/2024.
//

import UIKit
import Kingfisher
class CurrentWeatherView: UIView {

    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    
    @IBOutlet weak var currentImage: UIImageView!
    @IBOutlet weak var humditiyLabel: UILabel!
    
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        guard let view = loadFromNib() else {return}
        self.addSubview(view)
        view.frame = self.bounds
        self.layer.cornerRadius = Constants.cornerRadius
        self.layer.masksToBounds = true
    }
    
    func setup(location: Location, data: CurrentWeather) {
        self.cityLabel.text = location.name
        self.temperatureLabel.text = "\( data.temp_c ?? 0.0)°"
        self.weatherDescriptionLabel.text = data.condition?.text
        self.humditiyLabel.text = "Humidity: \(data.humidity ?? 0.0)"
        self.windSpeedLabel.text = "Wind speed: \(data.wind_mph ?? 0.0) mph"
        var iconUrl = data.condition?.icon ?? ""
        if iconUrl.starts(with: "//") {
            iconUrl = "https:\(iconUrl)"
        }

        if  let url = URL(string: iconUrl) {
            currentImage.kf.setImage(with: url)
            currentImage.isHidden = false
        } else {
            currentImage.isHidden = true
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

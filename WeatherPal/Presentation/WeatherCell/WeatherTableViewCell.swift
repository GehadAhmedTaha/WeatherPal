//
//  WeatherTableViewCell.swift
//  WeatherPal
//
//  Created by Gehad V on 12/10/2024.
//

import UIKit
import Kingfisher

class WeatherTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var conditionDescLabel: UILabel!
    @IBOutlet weak var conditionIcon: UIImageView!
        @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = Constants.cornerRadius
        self.layer.masksToBounds = true
    }

    func setup(data: ForecastDay){
        guard let date = data.date,
                let day = data.day else {return}
        dateLabel.text = date
        conditionDescLabel.text = day.condition?.text
        var iconUrl = day.condition?.icon ?? ""
        if iconUrl.starts(with: "//") {
            iconUrl = "https:\(iconUrl)"
        }

        if  let url = URL(string: iconUrl) {
            conditionIcon.kf.setImage(with: url)
            conditionIcon.isHidden = false
        } else {
            conditionIcon.isHidden = true
        }
        
        highTempLabel.text = "H:\(day.maxtemp_c ?? 0.0)°"
        lowTempLabel.text = "L:\(day.mintemp_c ?? 0.0)°"
    }
    
    
}

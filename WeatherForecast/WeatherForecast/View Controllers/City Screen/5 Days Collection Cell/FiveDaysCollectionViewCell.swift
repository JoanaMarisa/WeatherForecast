//
//  FiveDaysCollectionViewCell.swift
//  WeatherForecast
//
//  Created by Joana Henriques on 03/03/2020.
//  Copyright © 2020 Joana Henriques. All rights reserved.
//

import UIKit

class FiveDaysCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var dayOfTheWeek: UILabel!
    
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var temperatureUnit: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var dailyForecastRowViewModel : DailyForecastRowViewModel? {
        
         didSet {
            
            dayOfTheWeek.text = dailyForecastRowViewModel?.title
        
            temperature.text = dailyForecastRowViewModel?.temperature
            
            let defaults = UserDefaults.standard
            let units : String = defaults.string(forKey: userDefaultsUnitSystemKey) ?? metricValue
            
            var selectedUnit = "º"
            if (units == imperialValue) {
                selectedUnit = "ºF"
            }
            
            temperatureUnit.text = selectedUnit
            
        }
        
    }

}

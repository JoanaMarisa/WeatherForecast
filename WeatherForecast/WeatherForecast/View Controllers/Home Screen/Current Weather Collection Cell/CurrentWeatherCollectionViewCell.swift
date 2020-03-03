//
//  CurrentWeatherCollectionViewCell.swift
//  WeatherForecast
//
//  Created by Joana Henriques on 27/02/2020.
//  Copyright © 2020 Joana Henriques. All rights reserved.
//

import UIKit

class CurrentWeatherCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var weatherIcon: UIImageView?
    @IBOutlet weak var cityTextLabel: UILabel!
    @IBOutlet weak var temperatureValueLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    var goodWeatherColor = UIColor.init(red: 130/255, green: 188/255, blue: 200/255, alpha: 1)
    var mediumWeatherColor = UIColor.init(red: 5/255, green: 51/255, blue: 62/255, alpha: 0.7)
    var badWeatherColor = UIColor.init(red: 5/255, green: 41/255, blue: 52/255, alpha: 0.85)
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var currentWeatherForecastViewModel : List? {

            didSet {

                let currentWeather = currentWeatherForecastViewModel?.weather.first
                let currentMain = currentWeatherForecastViewModel?.main
                
                weatherIcon?.image = getIconForCurrentWeather(currentWeather: currentWeather!.main)
                
                switch currentWeather?.main {
                case "Clouds":
                    contentView.backgroundColor = mediumWeatherColor
                    break
                    
                case "Clear":
                    contentView.backgroundColor = goodWeatherColor
                    break
                    
                case "Snow":
                    contentView.backgroundColor = badWeatherColor
                    break
                    
                case "Rain":
                    contentView.backgroundColor = badWeatherColor
                    break
                    
                case "Haze":
                    contentView.backgroundColor = mediumWeatherColor
                    break
                    
                case "Drizzle":
                    contentView.backgroundColor = badWeatherColor
                    break
                    
                default:
                    contentView.backgroundColor = mediumWeatherColor
                    break
                }

                let temp: Int = Int(currentMain!.temp)

                let defaults = UserDefaults.standard
                let units : String = defaults.string(forKey: userDefaultsUnitSystemKey) ?? metricValue
                
                var temperatureUnit = "º"
                if (units == imperialValue) {
                    temperatureUnit = "ºF"
                }
                
                let currentCountry = ", ".appending(currentWeatherForecastViewModel?.sys.country ?? "")
                cityTextLabel.text = currentWeatherForecastViewModel?.name.appending(currentCountry)
                
                temperatureValueLabel.text = String(format: "%d", temp).appending(temperatureUnit)
                
            }
        
        }
    
}

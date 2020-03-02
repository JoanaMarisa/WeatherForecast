//
//  WeatherInfoUtilities.swift
//  WeatherForecast
//
//  Created by Joana Henriques on 02/03/2020.
//  Copyright © 2020 Joana Henriques. All rights reserved.
//

import UIKit

func getIconForCurrentWeather(currentWeather: String) -> UIImage {
    
    switch currentWeather {
            case "Clouds":
                return UIImage(named: "cloudsAndSun")!
                       
            case "Clear":
                return UIImage(named: "sun")!
                       
            case "Snow":
                return UIImage(named: "snow")!
                       
            case "Rain":
                return UIImage(named: "rain")!
                       
            case "Haze":
                return UIImage(named: "cloudsAndSun")!
                       
            case "Drizzle":
                return UIImage(named: "rainWithClouds")!
                       
            default:
                return UIImage(named: "cloudsAndSun")!
                   
    }
    
}

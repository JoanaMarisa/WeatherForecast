//
//  FiveDaysForecastResponses.swift
//  WeatherForecast
//
//  Created by Joana Henriques on 03/03/2020.
//  Copyright © 2020 Joana Henriques. All rights reserved.
//

import Foundation

// MARK: - FiveDaysForecastResponses
struct FiveDaysForecastResponses: Codable {
    
    let list: [Item]
    
    struct Item: Codable {
        
      let date: Date
      let main: MainClass
      let weather: [Weather]
      
      enum CodingKeys: String, CodingKey {
        
        case date = "dt"
        case main
        case weather
        
      }
        
    }
    
    struct MainClass: Codable {
      let temp: Double
    }
    
    struct Weather: Codable {
        
      let main: MainEnum
      let weatherDescription: String
      
      enum CodingKeys: String, CodingKey {
        
        case main
        case weatherDescription = "description"
        
      }
        
    }
    
    enum MainEnum: String, Codable {
        
      case clear = "Clear"
      case clouds = "Clouds"
      case rain = "Rain"
        
    }

}

//
//  WeatherForecastResponses.swift
//  WeatherForecast
//
//  Created by Joana Henriques on 26/02/2020.
//  Copyright © 2020 Joana Henriques. All rights reserved.
//

import Foundation

struct CurrentWeatherForecastResponse: Decodable {
    
    let main: Main
  
    struct Main: Codable {
    
         let temperature: Double
    
        enum CodingKeys: String, CodingKey {
            case temperature = "temp"
        }
    
    }

    
}

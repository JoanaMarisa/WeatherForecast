//
//  CurrentWeatherViewModel.swift
//  WeatherForecast
//
//  Created by Joana Henriques on 26/02/2020.
//  Copyright © 2020 Joana Henriques. All rights reserved.
//

import Foundation

struct CurrentWeatherCollectionCellViewModel {
    
    private let item: CurrentWeatherForecastResponse
  
    var temperature: String {
        return String(format: "%.1f", item.main.temperature)
    }
  
    init(item: CurrentWeatherForecastResponse) {
        self.item = item
    }
    
}

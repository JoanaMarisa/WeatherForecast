//
//  WeatherForecastError.swift
//  WeatherForecast
//
//  Created by Joana Henriques on 26/02/2020.
//  Copyright © 2020 Joana Henriques. All rights reserved.
//

import Foundation

enum WeatherForecastError: Error {

    case parsing(description: String)
    case network(description: String)

}

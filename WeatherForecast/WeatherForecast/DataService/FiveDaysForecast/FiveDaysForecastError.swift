//
//  FiveDaysForecastError.swift
//  WeatherForecast
//
//  Created by Joana Henriques on 03/03/2020.
//  Copyright © 2020 Joana Henriques. All rights reserved.
//

import Foundation

enum FiveDaysForecastError: Error {

    case parsing(description: String)
    case network(description: String)

}

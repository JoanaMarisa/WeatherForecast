//
//  Formatters.swift
//  WeatherForecast
//
//  Created by Joana Henriques on 03/03/2020.
//  Copyright © 2020 Joana Henriques. All rights reserved.
//

import Foundation

let dayFormatter: DateFormatter = {
    
    let formatter = DateFormatter()
    formatter.dateFormat = "dd"
    return formatter

}()

let monthFormatter: DateFormatter = {

    let formatter = DateFormatter()
    formatter.dateFormat = "MM"
    return formatter

}()

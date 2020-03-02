//
//  SupportedCitiesResponses.swift
//  WeatherForecast
//
//  Created by Joana Henriques on 02/03/2020.
//  Copyright © 2020 Joana Henriques. All rights reserved.
//

import Foundation

// MARK: - WelcomeElement

struct CityElement: Codable {

    let id: Int
    let name, country: String
    let coord: Coordinate

}

// MARK: - Coord

struct Coordinate: Codable {
    let lon, lat: Double
}

typealias Cities = [CityElement]

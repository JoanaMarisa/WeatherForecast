//
//  SupportedCitiesFetcher.swift
//  WeatherForecast
//
//  Created by Joana Henriques on 02/03/2020.
//  Copyright © 2020 Joana Henriques. All rights reserved.
//

import Foundation

class SupportedCitiesFetcher {

    // MARK: Properties

    private var cityListChache =  Cities()
    private let cityListFilePath: URL

    // MARK: Initializer

    public init(cityListFilePath: URL) {
        self.cityListFilePath = cityListFilePath
    }
    
}

protocol SupportedCitiesFetchable {
    func supportedCountries() -> Cities
}

extension SupportedCitiesFetcher: SupportedCitiesFetchable {
    
    // MARK: CityService confirmance

    func supportedCountries() -> Cities {

        let data = try! Data(contentsOf: self.cityListFilePath)
        let sortedCountries = try! JSONDecoder().decode([CityElement].self, from: data).sorted { $0.name < $1.name }
            
        return sortedCountries
    
    }

}

// MARK: - Errors

public enum CityServiceError: Error {
    case missingData
}

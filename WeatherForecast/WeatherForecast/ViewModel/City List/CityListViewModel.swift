//
//  CityListViewModel.swift
//  WeatherForecast
//
//  Created by Joana Henriques on 02/03/2020.
//  Copyright © 2020 Joana Henriques. All rights reserved.
//

import Foundation

class CityListViewModel: ObservableObject {

    var supportedCities: Cities = []
    private var allSupportedCitites: Cities = []
    
    private let cityFecther: SupportedCitiesFetcher

    var isLoading: Bool = false {
        
        didSet {
            self.updateLoadingStatus?()
        }
        
    }
    
    var updateLoadingStatus: (()->())?
    
    // MARK: Initializer

    init(cityFecther: SupportedCitiesFetcher) {
        self.cityFecther = cityFecther
    }
    
    
    // MARK: Public methods

    func update() {
        
        self.isLoading = true
        getSupportedCountries()
        
    }
    
    func searchCity(searchTerm: String) -> Cities {
        
        resetSearch()
        
        func filterSeach(city: CityElement) -> Bool {
            
            guard !searchTerm.isEmpty else { return true }
            let searchStringList = searchTerm.lowercased()
            let contained = (searchStringList == city.name.lowercased())

            return contained
            
        }

        return self.supportedCities.filter(filterSeach)

    }
    
    func searchCityWithCoord(cityName: String, latitude: Double) -> Cities {
        
        resetSearch()
        
        func filterSeach(city: CityElement) -> Bool {
            
            guard !cityName.isEmpty else { return true }
            
            let searchCityNameStringList = cityName.lowercased()

            let contained = (searchCityNameStringList == city.name.lowercased() && (latitude < city.coord.lat + 1 && latitude > city.coord.lat - 1))
            return contained
            
        }

        return self.supportedCities.filter(filterSeach)

    }
    
    func resetSearch() {
        self.supportedCities = self.allSupportedCitites
    }
        
    // MARK: Private helper

    private func getSupportedCountries() {
        
        self.allSupportedCitites = cityFecther.supportedCountries()
        self.supportedCities = allSupportedCitites
        self.isLoading = false
        
    }
    
}

//
//  WeatherForecastViewModel.swift
//  WeatherForecast
//
//  Created by Joana Henriques on 26/02/2020.
//  Copyright © 2020 Joana Henriques. All rights reserved.
//

import Foundation
import Combine

class CurrentWeatherForecastViewModel: ObservableObject {
    
    @Published var dataSource: CurrentWeatherCollectionCellViewModel?

    let cities: String
    
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    private let weatherForecastFetcher: WeatherForecastFetchable
    private var disposables = Set<AnyCancellable>()
        
    var updateLoadingStatus: (()->())?

    init(cities: String, weatherFetcher: WeatherForecastFetchable) {
    
        self.weatherForecastFetcher = weatherFetcher
        self.cities = cities
  
    }
  
    func refresh() {
    
        weatherForecastFetcher.currentWeatherForecastForCities(forCities: cities)
            .map(CurrentWeatherCollectionCellViewModel.init)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] value in
        
                guard let self = self else { return }
        
                switch value {
            
                    case .failure:
                        self.dataSource = nil
                    case .finished:
                        break
        
                }
        
            }, receiveValue: { [weak self] weather in
        
                guard let self = self else { return }
                self.dataSource = weather
               
                self.isLoading = false
        
            }).store(in: &disposables)
    
  }
    
}


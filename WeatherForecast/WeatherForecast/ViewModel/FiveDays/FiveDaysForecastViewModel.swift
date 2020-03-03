//
//  FiveDaysForecastViewModel.swift
//  WeatherForecast
//
//  Created by Joana Henriques on 03/03/2020.
//  Copyright © 2020 Joana Henriques. All rights reserved.
//

import Foundation
import Combine

class FiveDaysForecastViewModel: ObservableObject {
    
    @Published var dataSource: [DailyForecastRowViewModel] = []

    let cities: String
    
    var isLoading: Bool = false {
        didSet {
            updateLoadingStatus?()
        }
    }
    
    private let fiveDaysForecastFetcher: FiveDaysForecastFetchable
    private var disposables = Set<AnyCancellable>()
        
    var updateLoadingStatus: (()->())?

    init(cities: String, fiveDaysFetcher: FiveDaysForecastFetchable) {
    
        self.fiveDaysForecastFetcher = fiveDaysFetcher
        self.cities = cities
  
    }
  
func refresh(forCity city: String) {

        fiveDaysForecastFetcher.fiveDaysForecastForecastForCities(forCity: cities)
            .map { response in
              response.list.map(DailyForecastRowViewModel.init)
            }
            .receive(on: DispatchQueue.main)
            .sink(
              receiveCompletion: { [weak self] value in
                guard let self = self else { return }
                switch value {
                    
                case .failure:
                  self.dataSource = []
                    
                case .finished:
                  break
                }
                
              },
              receiveValue: { [weak self] forecast in
                
                guard let self = self else { return }
                self.dataSource = forecast
                self.isLoading = false
                
            })
            .store(in: &disposables)
    
        }

  }

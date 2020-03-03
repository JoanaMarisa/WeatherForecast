//
//  FiveDaysForecastFetcher.swift
//  WeatherForecast
//
//  Created by Joana Henriques on 03/03/2020.
//  Copyright © 2020 Joana Henriques. All rights reserved.
//

import Foundation
import Combine


class FiveDaysForecastFetcher {
    
    private let session: URLSession
  
    init(session: URLSession = .shared) {
        self.session = session
    }
    
}

protocol FiveDaysForecastFetchable {
    func fiveDaysForecastForecastForCities( forCity city: String ) -> AnyPublisher<FiveDaysForecastResponses, FiveDaysForecastError>
}
    
private extension FiveDaysForecastFetcher {

    struct FiveDaysAPIStructure {
  
        static let scheme = "https"
        static let host = "api.openweathermap.org"
        static let path = "/data/2.5"
        static let key = "c6e381d8c7ff98f0fee43775817cf6ad"

    }

    func createFiveDaysForecastComponentsWithCities( withCity city: String ) -> URLComponents {
        
        let defaults = UserDefaults.standard
        let units : String = defaults.string(forKey: userDefaultsUnitSystemKey) ?? metricValue
        
        var components = URLComponents()
        components.scheme = FiveDaysAPIStructure.scheme
        components.host = FiveDaysAPIStructure.host
        components.path = FiveDaysAPIStructure.path + "/forecast"
      
        components.queryItems = [
            URLQueryItem(name: "id", value: city),
            URLQueryItem(name: "mode", value: "json"),
            URLQueryItem(name: "units", value: units),
            URLQueryItem(name: "appid", value: FiveDaysAPIStructure.key)
        ]
      
        return components
        
    }
    
}


// MARK: - FiveDaysForecastFetchable

extension FiveDaysForecastFetcher: FiveDaysForecastFetchable {
    
    func fiveDaysForecastForecastForCities( forCity city: String ) -> AnyPublisher<FiveDaysForecastResponses, FiveDaysForecastError> {
        return forecast(with: createFiveDaysForecastComponentsWithCities(withCity: city))
    }
    

    private func forecastForCities<T> ( with components: URLComponents ) -> AnyPublisher<T, FiveDaysForecastError> where T: Decodable {
        
        guard let url = components.url else {
            
          let error = FiveDaysForecastError.network(description: "Something wrong happened with the URL!")
          return Fail(error: error).eraseToAnyPublisher()
            
        }
        
        return session.dataTaskPublisher(for: URLRequest(url: url))
          .mapError { error in
            .network(description: error.localizedDescription)
          }
          .flatMap(maxPublishers: .max(1)) { pair in
            decode(pair.data)
          }
          .eraseToAnyPublisher()
        
    }
        

  private func forecast<T> ( with components: URLComponents ) -> AnyPublisher<T, FiveDaysForecastError> where T: Decodable {
    
    guard let url = components.url else {
        
      let error = FiveDaysForecastError.network(description: "Something wrong happened with the URL!")
      return Fail(error: error).eraseToAnyPublisher()
        
    }
    
    return session.dataTaskPublisher(for: URLRequest(url: url))
      .mapError { error in
        .network(description: error.localizedDescription)
      }
      .flatMap(maxPublishers: .max(1)) { pair in
        decode(pair.data)
      }
      .eraseToAnyPublisher()
  }
    
}


// MARK: - Parsing

func decode<T: Decodable>(_ data: Data) -> AnyPublisher<T, FiveDaysForecastError> {
    
  let decoder = JSONDecoder()
  decoder.dateDecodingStrategy = .secondsSince1970

  return Just(data)
    .decode(type: T.self, decoder: decoder)
    .mapError { error in
      .parsing(description: error.localizedDescription)
    }
    .eraseToAnyPublisher()
    
}

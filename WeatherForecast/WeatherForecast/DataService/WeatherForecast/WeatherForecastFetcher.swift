//
//  WeatherOutput.swift
//  WeatherForecast
//
//  Created by Joana Henriques on 26/02/2020.
//  Copyright © 2020 Joana Henriques. All rights reserved.
//

import Foundation
import Combine


class WeatherForecastFetcher {
    
    private let session: URLSession
  
    init(session: URLSession = .shared) {
        self.session = session
    }
    
}

protocol WeatherForecastFetchable {
    func currentWeatherForecastForCities( forCities cities: String ) -> AnyPublisher<CurrentWeatherForecastResponse, WeatherForecastError>
}


    
private extension WeatherForecastFetcher {

    struct WeatherAPIStructure {
  
        static let scheme = "https"
        static let host = "api.openweathermap.org"
        static let path = "/data/2.5"
        static let key = "c6e381d8c7ff98f0fee43775817cf6ad"

    }

    func createCurrentWeatherForecastComponentsWithCities( withCities cities: String ) -> URLComponents {
        
        let defaults = UserDefaults.standard
        let units : String = defaults.string(forKey: userDefaultsUnitSystemKey) ?? metricValue
        
        var components = URLComponents()
        components.scheme = WeatherAPIStructure.scheme
        components.host = WeatherAPIStructure.host
        components.path = WeatherAPIStructure.path + "/group"
      
        components.queryItems = [
            URLQueryItem(name: "id", value: cities),
            URLQueryItem(name: "mode", value: "json"),
            URLQueryItem(name: "units", value: units),
            URLQueryItem(name: "appid", value: WeatherAPIStructure.key)
        ]
      
        return components
        
    }
    
}


// MARK: - WeatherForecastFetchable

extension WeatherForecastFetcher: WeatherForecastFetchable {
    
    func currentWeatherForecastForCities( forCities cities: String ) -> AnyPublisher<CurrentWeatherForecastResponse, WeatherForecastError> {
        return forecast(with: createCurrentWeatherForecastComponentsWithCities(withCities: cities))
    }

      private func forecastForCities<T> ( with components: URLComponents ) -> AnyPublisher<T, WeatherForecastError> where T: Decodable {
        
        guard let url = components.url else {
            
          let error = WeatherForecastError.network(description: "Something wrong happened with the URL!")
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
        

  private func forecast<T> ( with components: URLComponents ) -> AnyPublisher<T, WeatherForecastError> where T: Decodable {
    
    guard let url = components.url else {
        
      let error = WeatherForecastError.network(description: "Something wrong happened with the URL!")
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

func decode<T: Decodable>(_ data: Data) -> AnyPublisher<T, WeatherForecastError> {
    
  let decoder = JSONDecoder()
  decoder.dateDecodingStrategy = .secondsSince1970

  return Just(data)
    .decode(type: T.self, decoder: decoder)
    .mapError { error in
      .parsing(description: error.localizedDescription)
    }
    .eraseToAnyPublisher()
    
}

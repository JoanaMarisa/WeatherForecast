//
//  DailyForecastRowViewModel.swift
//  WeatherForecast
//
//  Created by Joana Henriques on 03/03/2020.
//  Copyright © 2020 Joana Henriques. All rights reserved.
//

import Foundation
import SwiftUI

struct DailyForecastRowViewModel: Identifiable {
    
  private let item: FiveDaysForecastResponses.Item
  
  var id: String {
//    return day + temperature + title
    return temperature + title
  }
  
//  var day: String {
//    return dayFormatter.string(from: item.date)
//  }
  
//  var month: String {
//    return monthFormatter.string(from: item.date)
//  }
  
  var temperature: String {
    return String(format: "%.1f", item.main.temp)
  }
  
  var title: String {
    guard let title = item.weather.first?.main.rawValue else { return "" }
    return title
  }
  
  var fullDescription: String {
    guard let description = item.weather.first?.weatherDescription else { return "" }
    return description
  }
  
  init(item: FiveDaysForecastResponses.Item) {
    self.item = item
  }
}

// Used to hash on just the day in order to produce a single view model for each
// day when there are multiple items per each day.
extension DailyForecastRowViewModel: Hashable {
  static func == (lhs: DailyForecastRowViewModel, rhs: DailyForecastRowViewModel) -> Bool {
    return true//return lhs.day == rhs.day
  }

  func hash(into hasher: inout Hasher) {
//    hasher.combine(self.day)
  }
}

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
        return day + title
    }
  
    var day: String {
        return dayFormatter.string(from: item.date)
    }
  
    var month: String {
        return monthFormatter.string(from: item.date)
    }

    var temperature: String {
        return String(format: "%.1f", item.main.temp)
    }
  
    var title: String {
        return day + "/" + month
    }
  
    init(item: FiveDaysForecastResponses.Item) {
        self.item = item
    }
    
}

extension DailyForecastRowViewModel: Hashable {
    
    static func == (lhs: DailyForecastRowViewModel, rhs: DailyForecastRowViewModel) -> Bool {
        return lhs.day == rhs.day
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.day)
    }
    
}

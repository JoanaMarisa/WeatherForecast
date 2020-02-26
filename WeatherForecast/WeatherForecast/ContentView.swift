//
//  ContentView.swift
//  WeatherForecast
//
//  Created by Joana Henriques on 26/02/2020.
//  Copyright © 2020 Joana Henriques. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: CurrentWeatherForecastViewModel

    init(viewModel: CurrentWeatherForecastViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
    
        List(content: content).onAppear(perform: viewModel.refresh)
            .navigationBarTitle(viewModel.city)
            .listStyle(GroupedListStyle())
  
    }
    
}

private extension ContentView {
    
    func content() -> some View {
    
        if let viewModel = viewModel.dataSource {
            return AnyView(details(for: viewModel))
        } else {
            return AnyView(loading)
        }
    
    }

    func details(for viewModel: CurrentWeatherCollectionCellViewModel) -> some View {
        CurrentWeatherCollectionCell(viewModel: viewModel)
    }

    var loading: some View {
        Text("Loading \(viewModel.city)'s weather...").foregroundColor(.gray)
    }
    
}

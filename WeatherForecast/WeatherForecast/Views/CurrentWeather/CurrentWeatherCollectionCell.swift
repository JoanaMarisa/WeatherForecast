//
//  CurrentWeatherCollectionCell.swift
//  WeatherForecast
//
//  Created by Joana Henriques on 26/02/2020.
//  Copyright © 2020 Joana Henriques. All rights reserved.
//

import SwiftUI


struct CurrentWeatherCollectionCell: View {
    
    private let viewModel: CurrentWeatherCollectionCellViewModel
      
    init(viewModel: CurrentWeatherCollectionCellViewModel) {
        self.viewModel = viewModel
    }
      
    var body: some View {
       
        VStack(alignment: .leading) {
    
            HStack {
                Text("Temperature:")
                Text("\(viewModel.temperature)°").foregroundColor(.gray)
            }
            
        }
        
    }
    
}

    

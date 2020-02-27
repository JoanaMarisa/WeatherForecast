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
      
    var image: String
    var category: String
    var heading: String
    
    init(viewModel: CurrentWeatherCollectionCellViewModel) {
        
        self.viewModel = viewModel
        self.image = "reallyHot"
        self.category = "category"
        self.heading = "heading"
//        self.category = viewModel.temperature
//        self.heading = viewModel.weatherDescription
        
    }
      
    var body: some View {
       
        HStack {
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
         
            VStack {
                VStack(alignment: .leading) {
                    Text(category)
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text(heading)
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundColor(.primary)
                        .lineLimit(3)
                }
                .layoutPriority(100)
         
                Spacer()
            }
            .padding([.top, .horizontal])
            
               VStack {
                   VStack(alignment: .leading) {
                       Text(category)
                           .font(.headline)
                           .foregroundColor(.secondary)
                       Text(heading)
                           .font(.title)
                           .fontWeight(.black)
                           .foregroundColor(.primary)
                           .lineLimit(3)
                   }
                   .layoutPriority(100)
            
                   Spacer()
               }
               .padding([.top, .horizontal])
            
               VStack {
                   VStack(alignment: .leading) {
                       Text(category)
                           .font(.headline)
                           .foregroundColor(.secondary)
                       Text(heading)
                           .font(.title)
                           .fontWeight(.black)
                           .foregroundColor(.primary)
                           .lineLimit(3)
                   }
                   .layoutPriority(100)
            
                   Spacer()
               }
               .padding([.top, .horizontal])
        }
        
    
        
    }
    
}

    

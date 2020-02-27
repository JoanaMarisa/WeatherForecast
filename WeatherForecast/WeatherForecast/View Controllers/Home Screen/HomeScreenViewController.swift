//
//  HomeScreenViewController.swift
//  WeatherForecast
//
//  Created by Joana Henriques on 26/02/2020.
//  Copyright © 2020 Joana Henriques. All rights reserved.
//

import UIKit
import SwiftUI
import Combine

class HomeScreenViewController: UIViewController {

    var viewModel: CurrentWeatherForecastViewModel
    
    @IBOutlet weak var locationsCollectionView: UICollectionView!
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        
        let fetcher = WeatherForecastFetcher()
        self.viewModel = CurrentWeatherForecastViewModel(cities: "524901,703448,2643743", weatherFetcher: fetcher)
        super.init(nibName: String(describing:HomeScreenViewController.self), bundle: nil)
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        viewModel.updateLoadingStatus = { [weak self] () in
            DispatchQueue.main.async {
                
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                   print("Is loading")
                    
                } else {
                    print("Stop loading")
                }
                
            }
            
        }
        
        viewModel.refresh()

    }
    
    
}


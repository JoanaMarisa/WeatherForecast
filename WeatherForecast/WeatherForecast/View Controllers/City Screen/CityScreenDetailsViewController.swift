//
//  CityScreenDetailsViewController.swift
//  WeatherForecast
//
//  Created by Joana Henriques on 01/03/2020.
//  Copyright © 2020 Joana Henriques. All rights reserved.
//

import UIKit

class CityScreenDetailsViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var rainChancesLabel: UILabel!
    @IBOutlet weak var windInfoLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
    var location: List
    
    init(location: List) {
        
        self.location = location
        super.init(nibName: nil, bundle: nil)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.scrollView.delegate = self
     
        insertInfoToLayout()
    
    }
    
    func insertInfoToLayout() {
        
        self.cityLabel.text = location.name
        self.temperatureLabel.text = String(format: "%.fº", location.main.temp);
        
        let weather = location.weather.first
        self.infoLabel.text = weather?.weatherDescription
        
        self.maxTemperatureLabel.text =  String(format: "%.fº", location.main.tempMax);
        self.minTemperatureLabel.text = String(format: "%.fº", location.main.tempMin);
        self.humidityLabel.text =  String(format: "%d", location.main.humidity);
        self.rainChancesLabel.text = "1"
        
        self.windInfoLabel.text = String(format: "%.f", location.wind.speed)
        self.rainChancesLabel.text = String(format: "%.f", location.precipitation ?? "-")
        
        self.iconImage.image = getIconForCurrentWeather(currentWeather: weather!.main)
        
    }

}

extension CityScreenDetailsViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scrollView.contentOffset.x = 0
    }
    
}

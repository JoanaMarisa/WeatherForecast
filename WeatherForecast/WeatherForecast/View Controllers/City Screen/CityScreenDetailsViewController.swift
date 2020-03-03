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
    @IBOutlet weak var speedUnitLabel: UILabel!

    @IBOutlet weak var fiveDaysCollectionView: UICollectionView!

    
    let fetcher = FiveDaysForecastFetcher()
    lazy var viewModel: FiveDaysForecastViewModel = {
        return FiveDaysForecastViewModel(cities: self.cityID, fiveDaysFetcher: self.fetcher)
    }()
    
    var location: List
    var cityID : String
    
    init(location: List, cityID: String) {
        
        self.location = location
        self.cityID = cityID
        super.init(nibName: nil, bundle: nil)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initFiveDaysCollectionView() {
        
        viewModel = FiveDaysForecastViewModel(cities: cityID, fiveDaysFetcher: self.fetcher)
        
        let cellNib = UINib(nibName: String(describing: FiveDaysCollectionViewCell.self), bundle: nil)
        fiveDaysCollectionView.register(cellNib, forCellWithReuseIdentifier: String(describing: FiveDaysCollectionViewCell.self))
        
        fiveDaysCollectionView.delegate = self
        fiveDaysCollectionView.dataSource = self
    
        reloadCollectionView()
        
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        scrollView.delegate = self
     
        applyUIConfigs()
        initFiveDaysCollectionView()
        
    }
    
    func applyUIConfigs() {
        
        let defaults = UserDefaults.standard
        let units : String = defaults.string(forKey: userDefaultsUnitSystemKey) ?? metricValue
        
        var temperatureUnit = "º"
        var speedUnit = "m/s"
        if (units == imperialValue) {

            temperatureUnit = "ºF"
            speedUnit = "mph"
            
        }
        
        let currentCountry = ", ".appending(location.sys.country)
        cityLabel.text = location.name.appending(currentCountry)
        
        temperatureLabel.text = String(format: "%.f", location.main.temp).appending(temperatureUnit);
        
        let weather = location.weather.first
        infoLabel.text = weather?.weatherDescription
        
        maxTemperatureLabel.text =  String(format: "%.f", location.main.tempMax).appending(temperatureUnit);
        minTemperatureLabel.text = String(format: "%.f", location.main.tempMin).appending(temperatureUnit);
        humidityLabel.text =  String(format: "%d", location.main.humidity);
        rainChancesLabel.text = "1"
        
        windInfoLabel.text = String(format: "%.f", location.wind.speed)
        rainChancesLabel.text = String(format: "%.f", location.precipitation ?? "-")
        speedUnitLabel.text = speedUnit
        
        iconImage.image = getIconForCurrentWeather(currentWeather: weather!.main)
        
    }
    
    // MARK: Collection Support Methods
    
    func reloadCollectionView() {
        
        viewModel.updateLoadingStatus = { [weak self] () in
            DispatchQueue.main.async {
                
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                   print("Is loading")
                } else {
                    
                    print("Stop loading")
                    self?.fiveDaysCollectionView.reloadData()
                
                }
                
            }
            
        }
        
        viewModel.refresh(forCity: cityID)
        
    }

}


extension CityScreenDetailsViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.x = 0
    }
    
}


extension CityScreenDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: FiveDaysCollectionViewCell.self),
                                                            for: indexPath) as? FiveDaysCollectionViewCell else {
            fatalError("Cell not exists in storyboard")
        }

        cell.dailyForecastRowViewModel = self.viewModel.dataSource[indexPath.row]
        return cell
        
    }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let availableWidth = self.fiveDaysCollectionView.bounds.size.width / 6
        
        return CGSize(width: availableWidth, height: 60)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
      return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 2.0)
    }

    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0
    }
    
}


extension Date {
    
    func dayOfWeek() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        return dateFormatter.string(from: self).capitalized
        
    }
    
}




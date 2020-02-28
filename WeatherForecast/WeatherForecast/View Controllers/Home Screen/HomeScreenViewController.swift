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
    var locations: [List]!
    
    @IBOutlet weak var locationsCollectionView: UICollectionView!
    @IBOutlet weak var heightCollectionConstraint: NSLayoutConstraint!
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        
        let fetcher = WeatherForecastFetcher()
        self.viewModel = CurrentWeatherForecastViewModel(cities: "2766444,703448,1255364,7873305,2643743", weatherFetcher: fetcher)
        super.init(nibName: String(describing:HomeScreenViewController.self), bundle: nil)
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        let cellNib = UINib(nibName: String(describing: CurrentWeatherCollectionViewCell.self), bundle: nil)
        self.locationsCollectionView.register(cellNib, forCellWithReuseIdentifier: String(describing: CurrentWeatherCollectionViewCell.self))
        
        self.locationsCollectionView.delegate = self
        self.locationsCollectionView.dataSource = self

        viewModel.updateLoadingStatus = { [weak self] () in
            DispatchQueue.main.async {
                
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                   print("Is loading")
                } else {
                    
                    print("Stop loading")
                    let locations = self?.viewModel.dataSource?.citiesList
                    self?.locations = locations!
                    self?.locationsCollectionView.reloadData()
                
                }
                
            }
            
        }
        
        viewModel.refresh()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
}

extension HomeScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.locations?.count ?? 0;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CurrentWeatherCollectionViewCell.self),
                                                            for: indexPath) as? CurrentWeatherCollectionViewCell else {
            fatalError("Cell not exists in storyboard")
        }
        
        cell.layer.cornerRadius = 10.0
        cell.contentView.layer.cornerRadius = 10.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = false;

        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width:0,height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false;
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath

        cell.deleteButton.addTarget(self, action: #selector(deleteLocationTapped), for: .touchUpInside)
        cell.deleteButton.tag = indexPath.row
        
        cell.currentWeatherForecastViewModel = locations[indexPath.row]
        return cell
        
    }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if isLandscape {
            
            let availableWidth = self.locationsCollectionView.bounds.size.width / 6
            let availableHeight = self.view.bounds.size.height / 3
                
            self.heightCollectionConstraint.constant = availableHeight + 20
            return CGSize(width: availableWidth, height: availableHeight)
            
        } else {
            
            let availableWidth = self.locationsCollectionView.bounds.size.width / 3
            let availableHeight = self.view.bounds.size.height / 4
            
            self.heightCollectionConstraint.constant = availableHeight + 10
            return CGSize(width: availableWidth, height: availableHeight)
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
      return UIEdgeInsets(top: 0.0, left: 40.0, bottom: 0.0, right: 30.0)
    }

    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    

    @objc func deleteLocationTapped(_ sender: UIButton) {
        
        self.locations.remove(at: sender.tag)
        
        DispatchQueue.main.async {
            self.locationsCollectionView.reloadData()
        }
        
    }

    
    var isLandscape: Bool {
        return UIApplication.shared.windows
            .first?
            .windowScene?
            .interfaceOrientation
            .isLandscape ?? false
    }
    
}




//
//  HomeScreenViewController.swift
//  WeatherForecast
//
//  Created by Joana Henriques on 26/02/2020.
//  Copyright © 2020 Joana Henriques. All rights reserved.
//

import UIKit
import SwiftUI
import MapKit
import CoreLocation


class HomeScreenViewController: UIViewController {

    var viewModel: CurrentWeatherForecastViewModel!
    var locations: [List]!

    let fetcher = WeatherForecastFetcher()
    var cityListViewModel: CityListViewModel
    var bookmarkedCitiesIDs: String! = String()
    
    let locationManager = CLLocationManager()
    var myLocation:CLLocationCoordinate2D?
    
    @IBOutlet weak var locationsCollectionView: UICollectionView!
    @IBOutlet weak var heightCollectionConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var mapViewKit: MKMapView!
    
    @IBOutlet weak var zoomInButton: UIButton!
    @IBOutlet weak var zoomOutButton: UIButton!
    @IBOutlet weak var addNewLocationsView: UIView!
    
    
    // MARK: Initializers
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        
        let citiesFetcher = SupportedCitiesFetcher(cityListFilePath:  Bundle.main.url(forResource: "cities", withExtension: "json")!)
        self.cityListViewModel = CityListViewModel(cityFecther: citiesFetcher)
        super.init(nibName: String(describing:HomeScreenViewController.self), bundle: nil)
        
    }
    
    func initLocationsCollectionView() {
        
        let cellNib = UINib(nibName: String(describing: CurrentWeatherCollectionViewCell.self), bundle: nil)
        self.locationsCollectionView.register(cellNib, forCellWithReuseIdentifier: String(describing: CurrentWeatherCollectionViewCell.self))
        
        self.locationsCollectionView.delegate = self
        self.locationsCollectionView.dataSource = self
    
        reloadCollectionView()
        
    }
    
    func initLocationManager() {
        
        if CLLocationManager.locationServicesEnabled() {
        
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()
        
        }

        self.mapViewKit.delegate = self
        self.mapViewKit.mapType = .standard
        self.mapViewKit.isZoomEnabled = true
        self.mapViewKit.isScrollEnabled = true

        if let coor = self.mapViewKit.userLocation.location?.coordinate{
            self.mapViewKit.setCenter(coor, animated: true)
        }
        
        addLongPressGesture()
        
    }
    
    func initButtons() {
        
        self.zoomInButton.setBackgroundImage(UIImage.init(named: "zoomIn"))
        self.zoomOutButton.setBackgroundImage(UIImage.init(named: "zoomOut"))
    
    }
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        initLocationManager()
        initButtons()
        initLocationsCollectionView()
        
        cityListViewModel.update()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.mapViewKit.showsUserLocation = true;
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.mapViewKit.showsUserLocation = false
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
        self.locationsCollectionView.reloadData()
        
    }
    
    
    // MARK: Location Support Methods
    
    func showMapPlaceholder() {
        self.mapView.isHidden = true
    }
    
    func addLongPressGesture() {
        
        let longPressRecogniser = UILongPressGestureRecognizer(target:self , action:#selector(handleLongPress(_:)))
        longPressRecogniser.minimumPressDuration = 0.6
        self.mapViewKit.addGestureRecognizer(longPressRecogniser)
        
    }
    
    @objc func handleLongPress(_ gestureRecognizer:UIGestureRecognizer) {
        
        if gestureRecognizer.state != .began{
            return
        }
        
        let touchPoint:CGPoint = gestureRecognizer.location(in: self.mapViewKit)
        let touchMapCoordinate:CLLocationCoordinate2D = self.mapViewKit.convert(touchPoint, toCoordinateFrom: self.mapViewKit)
        
        let annotation:MKPointAnnotation = MKPointAnnotation()
        annotation.coordinate = touchMapCoordinate
        
        self.mapViewKit.addAnnotation(annotation)
        self.centerMap(touchMapCoordinate)
        
    }
    
    
    // MARK: IBActions
    
    @IBAction func mapZoomIn(_ sender: Any) {
    
        var region: MKCoordinateRegion = mapViewKit.region
        region.span.latitudeDelta /= 2.0
        region.span.longitudeDelta /= 2.0
        self.mapViewKit.setRegion(region, animated: true)
        
    }
    
    @IBAction func mapZoomOut(_ sender: Any) {
           
        var region: MKCoordinateRegion = mapViewKit.region
        region.span.latitudeDelta = min(region.span.latitudeDelta * 2.0, 180.0)
        region.span.longitudeDelta = min(region.span.longitudeDelta * 2.0, 180.0)
        mapViewKit.setRegion(region, animated: true)
    
    }
    
    @IBAction func showHelpScreen(_ sender: Any) {
    
        let helpScreenViewController = HelpScreenViewController()
        present(helpScreenViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func addLocationsToList(_ sender: Any) {
        
        self.cityListViewModel.resetSearch()
        
        let alertController = UIAlertController(title: "Insert city:", message: "", preferredStyle: UIAlertController.Style.alert)

        alertController.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "City name"
        })
        
        alertController.addAction(UIAlertAction(title: "Search", style: UIAlertAction.Style.default, handler: { alert -> Void in
            
            let firstTextField = alertController.textFields![0] as UITextField
            let citiesFiltered = self.cityListViewModel.searchCity(searchTerm: firstTextField.text!)
            
            self.bookmarkedCitiesIDs = ""
            for (index, item) in citiesFiltered.enumerated() {
                
                if (index < 4) {
                    self.bookmarkedCitiesIDs.append(String(format: "%d,", item.id))
                } else {
                    break
                }
                
            }
            
            self.initLocationsCollectionView()
            
        }))

        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func reloadCollectionView() {
        
        self.viewModel = CurrentWeatherForecastViewModel(cities: self.bookmarkedCitiesIDs, weatherFetcher: self.fetcher)
        
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
    
}


extension HomeScreenViewController: CLLocationManagerDelegate, MKMapViewDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        centerMap(locValue)
        
     }
    
    func centerMap(_ center:CLLocationCoordinate2D){
        
        self.saveCurrentLocation(center)
        
        let latDelta: CLLocationDegrees = 0.10
        let lonDelta: CLLocationDegrees = 0.10
        
        let span = MKCoordinateSpan.init(latitudeDelta: latDelta, longitudeDelta: lonDelta)

        let newRegion = MKCoordinateRegion(center:center , span: span)
        self.mapViewKit.setRegion(newRegion, animated: true)
    
    }
    
    func saveCurrentLocation(_ center:CLLocationCoordinate2D) {
        
        print("\(center.latitude) , \(center.longitude)")
        self.myLocation = center
    
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        for annotation in self.mapViewKit.annotations {
            
            if (view.annotation?.coordinate.latitude == annotation.coordinate.latitude) &&
                (view.annotation?.coordinate.longitude == annotation.coordinate.longitude) {
                self.mapViewKit.removeAnnotation(annotation)
            }
            
        }
        
    }
    
}

extension HomeScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if (self.locations?.count ?? 0 > 0) {
            self.addNewLocationsView.isHidden = true
        } else {
            self.addNewLocationsView.isHidden = false
        }
        
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
            
            showMapPlaceholder()
            
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
        
        let cityScreenController = CityScreenDetailsViewController(location: self.locations[indexPath.row])
        present(cityScreenController, animated: true, completion: nil)
        
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




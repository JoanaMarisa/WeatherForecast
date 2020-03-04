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

    lazy var viewModel: CurrentWeatherForecastViewModel = {
        return CurrentWeatherForecastViewModel(cities: self.bookmarkedCitiesIDs, weatherFetcher: self.fetcher)
    }()

    lazy var locations: [List] = {
        return []
    }()
    
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
        locationsCollectionView.register(cellNib, forCellWithReuseIdentifier: String(describing: CurrentWeatherCollectionViewCell.self))
        
        locationsCollectionView.delegate = self
        locationsCollectionView.dataSource = self
    
        reloadCollectionView()
        
    }
    
    func initLocationManager() {
        
        if CLLocationManager.locationServicesEnabled() {
        
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        
        }

        mapViewKit.delegate = self
        mapViewKit.mapType = .standard
        mapViewKit.isZoomEnabled = true
        mapViewKit.isScrollEnabled = true

        if let coor = self.mapViewKit.userLocation.location?.coordinate {
            mapViewKit.setCenter(coor, animated: true)
        }
        
        addLongPressGesture()
        
    }
    
    func initButtons() {
        
        zoomInButton.setBackgroundImage(UIImage.init(named: "zoomIn"))
        zoomOutButton.setBackgroundImage(UIImage.init(named: "zoomOut"))
    
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
        mapViewKit.showsUserLocation = true;
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        mapViewKit.showsUserLocation = false
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
        locationsCollectionView.reloadData()
        
    }
    
    
    // MARK: Location Support Methods
        
    func addLongPressGesture() {
        
        let longPressRecogniser = UILongPressGestureRecognizer(target:self , action:#selector(handleLongPress(_:)))
        longPressRecogniser.minimumPressDuration = 0.6
        mapViewKit.addGestureRecognizer(longPressRecogniser)
        
    }
    
    @objc func handleLongPress(_ gestureRecognizer:UIGestureRecognizer) {
        
        if gestureRecognizer.state != .began{
            return
        }
        
        let touchPoint:CGPoint = gestureRecognizer.location(in: self.mapViewKit)
        let touchMapCoordinate:CLLocationCoordinate2D = self.mapViewKit.convert(touchPoint, toCoordinateFrom: self.mapViewKit)
        
        let annotation:MKPointAnnotation = MKPointAnnotation()
        annotation.coordinate = touchMapCoordinate
        
        mapViewKit.addAnnotation(annotation)
        centerMap(touchMapCoordinate)

        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { placemarks, error -> Void in

                guard let placeMark = placemarks?.first else { return }

                if ((placeMark.locality != nil) && (placeMark.country != nil)) {
                    
                    let citiesFiltered = self.cityListViewModel.searchCityWithCoord(cityName: placeMark.locality ?? "",  latitude: annotation.coordinate.latitude)
                    
                    self.bookmarkedCitiesIDs = ""
                    for (index, item) in citiesFiltered.enumerated() {
                        
                        if (index < 6) {
                            self.bookmarkedCitiesIDs.append(String(format: "%d,", item.id))
                        } else {
                            break
                        }
                        
                    }
                    
                    self.reloadCollectionView()
                    
                }
                
        })
        
    }
    
    
    // MARK: IBActions
    
    @IBAction func mapZoomIn(_ sender: Any) {
    
        var region: MKCoordinateRegion = mapViewKit.region
        region.span.latitudeDelta /= 2.0
        region.span.longitudeDelta /= 2.0
        mapViewKit.setRegion(region, animated: true)
        
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
    
    @IBAction func defineSettings(_ sender: Any) {
        
        let defaults = UserDefaults.standard
        
        let actionSheetController: UIAlertController = UIAlertController(title: "Select", message: "Unit system", preferredStyle: .actionSheet)

        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheetController.addAction(cancelAction)
        
        let selectMetricAction: UIAlertAction = UIAlertAction(title: "Metric", style: .default) { action -> Void in
            
            let unit = defaults.string(forKey: userDefaultsUnitSystemKey)
            defaults.set(metricValue, forKey: userDefaultsUnitSystemKey)
            
            if (unit != metricValue) {
                self.reloadCollectionView()
            }
            
        }
        actionSheetController.addAction(selectMetricAction)
        
        let selectImperialAction: UIAlertAction = UIAlertAction(title: "Imperial", style: .default) { action -> Void in
            
            let unit = defaults.string(forKey: userDefaultsUnitSystemKey)
            defaults.set(imperialValue, forKey: userDefaultsUnitSystemKey)
            
            if (unit != imperialValue) {
                self.reloadCollectionView()
            }
            
        }
        actionSheetController.addAction(selectImperialAction)

        present(actionSheetController, animated: true, completion: nil)
        
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
                
                if (index < 6) {
                    self.bookmarkedCitiesIDs.append(String(format: "%d,", item.id))
                } else {
                    break
                }
                
            }
            
            self.reloadCollectionView()
            
        }))

        self.present(alertController, animated: true, completion: nil)
        
    }
    
    // MARK: Collection Support Methods
    
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
        
        saveCurrentLocation(center)
        
        let latDelta: CLLocationDegrees = 0.10
        let lonDelta: CLLocationDegrees = 0.10
        
        let span = MKCoordinateSpan.init(latitudeDelta: latDelta, longitudeDelta: lonDelta)

        let newRegion = MKCoordinateRegion(center:center , span: span)
        mapViewKit.setRegion(newRegion, animated: true)
    
    }
    
    func saveCurrentLocation(_ center:CLLocationCoordinate2D) {
        
        print("\(center.latitude) , \(center.longitude)")
        myLocation = center
    
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        for annotation in self.mapViewKit.annotations {
            
            if (view.annotation?.coordinate.latitude == annotation.coordinate.latitude) &&
                (view.annotation?.coordinate.longitude == annotation.coordinate.longitude) {
                mapViewKit.removeAnnotation(annotation)
            }
            
        }
        
    }
    
}

extension HomeScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if (locations.count > 0) {
            addNewLocationsView.isHidden = true
        } else {
            addNewLocationsView.isHidden = false
        }
        
        return locations.count;
        
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
            
            mapView.isHidden = true
            
            let availableWidth = self.locationsCollectionView.bounds.size.width / 6
            let availableHeight = self.view.bounds.size.height / 3
                
            heightCollectionConstraint.constant = availableHeight + 20
            return CGSize(width: availableWidth, height: availableHeight)
            
        } else {
            
            mapView.isHidden = false
            
            let availableWidth = self.locationsCollectionView.bounds.size.width / 3
            let availableHeight = self.view.bounds.size.height / 4
            
            heightCollectionConstraint.constant = availableHeight + 10
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
        
        let allCitiesIDArray = bookmarkedCitiesIDs.components(separatedBy: ",")
        
        let cityScreenController = CityScreenDetailsViewController(location: self.locations[indexPath.row], cityID: allCitiesIDArray[indexPath.row])
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




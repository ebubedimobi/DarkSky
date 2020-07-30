//
//  MapViewController.swift
//  DarkSky
//
//  Created by Ebubechukwu Dimobi on 30.07.2020.
//  Copyright © 2020 blazeapps. All rights reserved.
//

import UIKit
import GoogleMaps
import RealmSwift


class MapViewController: UIViewController {
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var weatherConditionLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var showInfoOutlet: UIBarButtonItem!
    
    @IBOutlet weak var weatherView: UIView!
    var showWeather = true
    
    let cllocationManager = CLLocationManager()
    var locationManager = LocationManager()
    var hasInternetConnection = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.locationManagerDelegate = self
        
        
        mapView.settings.compassButton = true
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        
        getCurrentLocation()
        
    }
    
    
    private func getCurrentLocation(){
        
        cllocationManager.delegate = self
        cllocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        cllocationManager.requestWhenInUseAuthorization()
        cllocationManager.requestLocation()
        
    }
    
    @IBAction func showInfoButton(_ sender: UIBarButtonItem) {
        
        showWeather = !showWeather
        
        if showWeather{
            
            weatherView.isHidden = false
            showInfoOutlet.title = "Cкрыть Погоду"
            
        } else{
            weatherView.isHidden = true
            showInfoOutlet.title = "Показать Погоду"
            
        }
        
        
    }
    
    
}
//MARK: - CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
            cllocationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            
            locationManager.fetchWeather(using: lat, and: lon)
            
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}
//MARK: - LocationManagerDelegate


extension MapViewController: LocationManagerDelegate{
    func didUpdateWeather(with weatherModel: LocationModule) {
        
        
        DispatchQueue.main.async {
            
            self.degreeLabel.text = weatherModel.currentTempString
            self.weatherImage.image = UIImage(systemName: weatherModel.currentWeathImage)
            self.weatherConditionLabel.text = weatherModel.weatherCondition
        }
    }
    
    func didntUpdateWeather() {
        DispatchQueue.main.async {
            let realm = try! Realm()
            var locationCache: Results<LocationCache>?
            
            locationCache = realm.objects(LocationCache.self)
            
            if !(locationCache?.isEmpty ?? false){
                self.degreeLabel.text = locationCache?[0].currentTemp
                self.weatherImage.image = UIImage(systemName: locationCache?[0].currentWeathImage ?? "")
                self.weatherConditionLabel.text = locationCache?[0].weatherCondition
            }
            
        }
        
        
    }
    
    
    
    
    
}

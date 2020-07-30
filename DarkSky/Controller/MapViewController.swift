//
//  MapViewController.swift
//  DarkSky
//
//  Created by Ebubechukwu Dimobi on 30.07.2020.
//  Copyright © 2020 blazeapps. All rights reserved.
//

import UIKit
import GoogleMaps


class MapViewController: UIViewController {
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var weatherConditionLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    
    @IBOutlet weak var degreeLabel: UILabel!
    
    let cllocationManager = CLLocationManager()
    var locationManager = LocationManager()
    
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
        
        print(weatherModel.weatherCondition)
        DispatchQueue.main.async {
            
            self.degreeLabel.text = weatherModel.currentTempString
            self.weatherImage.image = UIImage(systemName: weatherModel.currentWeathImage)
            self.weatherConditionLabel.text = weatherModel.weatherCondition
        }
    }
    
    func didntUpdateWeather() {
        
    }
    
    
    
    
    
}

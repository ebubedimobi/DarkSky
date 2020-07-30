//
//  LocationManager.swift
//  DarkSky
//
//  Created by Ebubechukwu Dimobi on 30.07.2020.
//  Copyright © 2020 blazeapps. All rights reserved.
//

import Foundation
import RealmSwift

protocol LocationManagerDelegate {
    func didUpdateWeather(with weatherModel: LocationModule)
    func didntUpdateWeather()
}


struct LocationManager {
    
    var locationManagerDelegate: LocationManagerDelegate?
    
    func fetchWeather(using latitude: Double, and longitude: Double){
        let urlString = "\(Constants.baseURL)\(latitude),\(longitude)?units=si"
        
        performRequest(with: urlString)
        
    }
    
    //MARK: - perform GET Request
    private func performRequest(with urlString: String ){
        
        if let url = URL(string: urlString){
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                
                if error != nil {
                    //TODO: -  do delegate method to perform request when no internet
                    print("Network Problem please try again, switching to cache")
                    //updating info from cache
                    self.locationManagerDelegate?.didntUpdateWeather()
                    
                    return
                }
                
                
                if let safeData = data{
                    
                    if let locationModule = self.parseJSON(with: safeData){
                        
                      
                        DispatchQueue.main.async {
                            //TODO: -  update delegate method
                            
                            self.locationManagerDelegate?.didUpdateWeather(with: locationModule)
                            
                        }
                    }
                    
                }else {
                    print("Data is empty")
                    
                }
            }
            task.resume()
            
        }
        
    }
    
    private func parseJSON(with weatherData: Data)-> LocationModule? {
        
        
        let decoder = JSONDecoder()
        
        
        do{
            
            let decodedData = try decoder.decode(LocationData.self, from: weatherData)
            
            let weathToday = decodedData.currently.icon
            let tempToday = decodedData.currently.temperature
            let locationModule = LocationModule(currentWeathIcon: weathToday, currentTemp: tempToday)
            
            //save to cache
            deleteCacheToUpdate()
            
            let realm = try! Realm()
            let locationCache = LocationCache()
            
            locationCache.currentTemp = locationModule.currentTempString
            locationCache.currentWeathImage = locationModule.currentWeathImage
            locationCache.weatherCondition = locationModule.weatherCondition
            
            do{
                try realm.write{
                    
                    realm.add(locationCache)
                }
                
            }catch{
                print("error caching location context \(error)")
            }
            
            return locationModule
        }catch{
            
            print("error while decoding")
            return nil
        }
        
        
    }
    
    func deleteCacheToUpdate(){
        let realm = try! Realm()
        do{
            
            try realm.write{
                
                realm.delete(realm.objects(LocationCache.self))
            }
            
        }catch{
            print("error while saving")
        }
    }
    
    
}


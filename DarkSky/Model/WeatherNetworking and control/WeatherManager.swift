//
//  WeatherManager.swift
//  DarkSky
//
//  Created by Ebubechukwu Dimobi on 30.07.2020.
//  Copyright © 2020 blazeapps. All rights reserved.
//

import Foundation
import RealmSwift

protocol WeatherManagerDelegate {
    func didUpdateWeather(with weatherModel: [WeatherModel])
    func didntUpdateWeather(using selectedCityName: String)
}


struct WeatherManager {
    
    var cityName: String?
    var weatherManagerDelegate: WeatherManagerDelegate?
    
    mutating func fetchWeather(weatherURL: String, city: String){
        
        self.cityName = city
        performRequest(with: weatherURL)
        
        
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
                    self.weatherManagerDelegate?.didntUpdateWeather(using: self.cityName ?? "")
                    
                    return
                }
                
              
                
                if let safeData = data{
                    
                    if let weatherModel = self.parseJSON(with: safeData){
                        
                        DispatchQueue.main.async {
                            //TODO: -  update delegate method
                            
                            self.weatherManagerDelegate?.didUpdateWeather(with: weatherModel)
                            
                        }
                        
                    }
                    
                }else {
                    print("Data is empty")
                    
                }
            }
            task.resume()
            
        }
        
    }
    
    //MARK: - Decoding JSON
    private func parseJSON(with weatherData: Data)-> [WeatherModel]? {
        
        
        let decoder = JSONDecoder()
        var weatherArray = [WeatherModel]()
        
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let weathToday = decodedData.currently.icon
            let tempToday = decodedData.currently.temperature
            
            
            deleteCacheToUpdate()    //delete old cache
            
            for index in 0..<decodedData.daily.data.count{
                
                let dailyWeath = decodedData.daily.data[index].icon
                let dailyTemp = decodedData.daily.data[index].temperatureHigh
                let timeSince1970 = decodedData.daily.data[index].time
                
                weatherArray.append(WeatherModel(currentWeathIcon: weathToday, currentTemp: tempToday, dailyWeathIcon: dailyWeath, dailyTemp: dailyTemp, time: timeSince1970))
                
                
                
                
                //save to cache
                
                if self.cityName == "Petersburg"{
                    let realm = try! Realm()
                    
                    let petersburgCache = PetersburgCache()
                    
                    petersburgCache.currentTemp = weatherArray[index].currentTempString
                    petersburgCache.dailyTemp = weatherArray[index].dailyTempString
                    petersburgCache.date = weatherArray[index].dateString
                    petersburgCache.currentWeathImage = weatherArray[index].currentWeathImage
                    petersburgCache.dailyWeathImage = weatherArray[index].dailyWeatherImage
                    petersburgCache.weatherCondition = weatherArray[index].weatherCondition
                    
                    do{
                        try realm.write{
                            
                            realm.add(petersburgCache)
                        }
                        
                    }catch{
                        print("error caching petersburg context \(error)")
                    }
                    
                }else if self.cityName == "Moscow"{
                    let realm = try! Realm()
                    let moscowCache = MoscowCache()
                    
                    moscowCache.currentTemp = weatherArray[index].currentTempString
                    moscowCache.dailyTemp = weatherArray[index].dailyTempString
                    moscowCache.date = weatherArray[index].dateString
                    moscowCache.currentWeathImage = weatherArray[index].currentWeathImage
                    moscowCache.dailyWeathImage = weatherArray[index].dailyWeatherImage
                    moscowCache.weatherCondition = weatherArray[index].weatherCondition
                    
                    do{
                        try realm.write{
                            
                            realm.add(moscowCache)
                        }
                        
                    }catch{
                        print("error caching moscow context \(error)")
                    }
                    
                    
                }
                
                
            }
            
            return weatherArray
        }catch{
            
            print("could not parseJSON")
            print(error)
            return nil
        }
        
    }
    
    func deleteCacheToUpdate(){
        
        let realm = try! Realm()
        
        if self.cityName == "Petersburg"{
            
            
            do{
                
                try realm.write{
                    
                    realm.delete(realm.objects(PetersburgCache.self))
                }
            }catch{
                print("Error while deleting")
                
            }
        }else if self.cityName == "Moscow"{
            do{
                
                try realm.write{
                    
                    realm.delete(realm.objects(MoscowCache.self))
                }
            }catch{
                print("Error while deleting")
                
            }
            
            
        }
        
    }

}

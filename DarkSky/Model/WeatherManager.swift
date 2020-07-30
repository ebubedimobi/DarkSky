//
//  WeatherManager.swift
//  DarkSky
//
//  Created by Ebubechukwu Dimobi on 30.07.2020.
//  Copyright © 2020 blazeapps. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(with weatherModel: [WeatherModel])
}


struct WeatherManager {
    
    var weatherManagerDelegate: WeatherManagerDelegate?
    
    func fetchWeather(weatherURL: String){
        
        performRequest(with: weatherURL)
        
    }
    
    
    private func performRequest(with urlString: String ){
        
        if let url = URL(string: urlString){
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                
                if error != nil {
                    //TODO: -  do delegate method to perform request when no internet
                    print("Network Problem please try again")
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
    
    private func parseJSON(with weatherData: Data)-> [WeatherModel]? {
        
        let decoder = JSONDecoder()
        var weatherArray = [WeatherModel]()
        
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let weathToday = decodedData.currently.icon
            let tempToday = decodedData.currently.temperature
            
            for index in 0..<decodedData.daily.data.count{
                
                let dailyWeath = decodedData.daily.data[index].icon
                let dailyTemp = decodedData.daily.data[index].temperatureHigh
                let timeSince1970 = decodedData.daily.data[index].time
                
                weatherArray.append(WeatherModel(currentWeathIcon: weathToday, currentTemp: tempToday, dailyWeathIcon: dailyWeath, dailyTemp: dailyTemp, time: timeSince1970))
            }
          
            print(weatherArray[0].currentTemp)
            return weatherArray
        }catch{
            
            print("could not parseJSON")
            print(error)
            return nil
        }
        
    }
    
}

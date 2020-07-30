//
//  WeatherModel.swift
//  DarkSky
//
//  Created by Ebubechukwu Dimobi on 30.07.2020.
//  Copyright © 2020 blazeapps. All rights reserved.
//

import Foundation


struct WeatherModel{
    
    let currentWeathIcon: String
    let currentTemp: Double
    
    let dailyWeathIcon: String
    let dailyTemp: Double
    let time: Int
    
    var currentTempString: String{
        return String(format: "%.f", currentTemp)
        
    }
    
    var dailyTempString: String{
        return String(format: "%.f", dailyTemp)
        
    }
    
    var date: Date{
        return Date(timeIntervalSince1970: Double(time))
        
    }
    
    var currentWeathImage: String{
        
        return checkCondition(with: currentWeathIcon)
        
    }
    
    var dailyWeatherImage: String{
        return checkCondition(with: dailyWeathIcon)
    }
    
    private func checkCondition(with icon: String)-> String{
        
        switch icon {
        case "clear-day":
            return "sun.max"
        case "clear-night":
            return "moon"
        case "rain":
            return "cloud.rain"
        case "snow":
            return "snow"
        case "sleet", "wind":
            return "wind"
        case "cloudy","partly-cloudy-day","partly-cloudy-night":
            return "cloud"
        default:
            return "cloud"
        }
    }
    
    
    
    
}

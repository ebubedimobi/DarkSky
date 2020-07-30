//
//  LocationModule.swift
//  DarkSky
//
//  Created by Ebubechukwu Dimobi on 30.07.2020.
//  Copyright © 2020 blazeapps. All rights reserved.
//

import Foundation



struct LocationModule {
    let currentWeathIcon: String
    let currentTemp: Double
    
    var currentTempString: String{
        
        return String(format: "%.f", currentTemp )
        
        
    }
    
    var currentWeathImage: String{
        
        return checkCondition(with: currentWeathIcon)
        
        
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
    
    var weatherCondition: String{
       
            switch currentWeathIcon {
            case "clear-day", "clear-night":
                return "ЯСНО"
            case "rain":
                return "ДОЖДЬ"
            case "snow":
                return "СНЕГ"
            case "sleet", "wind":
                return "ВЕТЕР"
            case "cloudy","partly-cloudy-day","partly-cloudy-night":
                return "ОБЛАЧНО"
            default:
                return "ОБЛАЧНО"
            }
      
        
    }
    
    
    
    
}



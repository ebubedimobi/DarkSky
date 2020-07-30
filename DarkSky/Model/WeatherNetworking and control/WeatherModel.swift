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
    
    //MARK: - conversions to usable strings
    
    var currentTempString: String{
        get{
            return String(format: "%.f", currentTemp)
        }set {
            
        }
        
    }
    
    var dailyTempString: String{
        get{
            return String(format: "%.f", dailyTemp)
        }set{
            
        }
    }
    
    var dateString: String{
        get{
            let date = Date(timeIntervalSince1970: Double(time))
            
            let dateFormatter = DateFormatter()
            
            dateFormatter.locale = Locale(identifier: "ru_RU")
            
            dateFormatter.timeStyle = .none
            dateFormatter.dateFormat = "E, d MMM"
            
            
            return dateFormatter.string(from: date)
        }set {
            
            
        }
    }
    
    var currentWeathImage: String{
        get{
            return checkCondition(with: currentWeathIcon)
        }set{
            
        }
        
    }
    
    var dailyWeatherImage: String{
        get{
            return checkCondition(with: dailyWeathIcon)
        }set{
            
        }
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
        get{
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
        }set{
            
        }
        
    }
    
    
    
    
}






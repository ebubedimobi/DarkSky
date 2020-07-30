//
//  WeatherData.swift
//  DarkSky
//
//  Created by Ebubechukwu Dimobi on 30.07.2020.
//  Copyright © 2020 blazeapps. All rights reserved.
//

import Foundation


struct weatherData: Codable{
    
    let currently: Currently
    let daily: Daily
}

struct Currently: Codable {
    
    let icon: String
    let temperature: Double
}


struct Daily: Codable {
    
    let data: [DailyData]
}

struct DailyData: Codable {
    let icon: String
    let temperature: Double
    let time: Int
}

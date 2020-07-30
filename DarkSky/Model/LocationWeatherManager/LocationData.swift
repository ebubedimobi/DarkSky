//
//  LocationData.swift
//  DarkSky
//
//  Created by Ebubechukwu Dimobi on 30.07.2020.
//  Copyright © 2020 blazeapps. All rights reserved.
//

import Foundation

struct LocationData: Codable{
    
    let currently: Now
    
}

struct Now: Codable {
    
    let icon: String
    let temperature: Double
}

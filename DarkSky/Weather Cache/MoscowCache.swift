//
//  File.swift
//  DarkSky
//
//  Created by Ebubechukwu Dimobi on 30.07.2020.
//  Copyright © 2020 blazeapps. All rights reserved.
//

import Foundation
import RealmSwift

class MoscowCache : Object{
    
    @objc dynamic var currentTemp: String = ""
    @objc dynamic var dailyTemp: String = ""
    @objc dynamic var date: String = ""
    @objc dynamic var currentWeathImage: String = ""
    @objc dynamic var dailyWeathImage: String = ""
    @objc dynamic var weatherCondition: String = ""
    
    
}

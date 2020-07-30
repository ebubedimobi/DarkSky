//
//  ViewController.swift
//  DarkSky
//
//  Created by Ebubechukwu Dimobi on 30.07.2020.
//  Copyright © 2020 blazeapps. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController  {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewWeatherImage: UIImageView!
    @IBOutlet weak var viewDegreeLabel: UILabel!
    @IBOutlet weak var PetersburgButtonOutlet: UIButton!
    @IBOutlet weak var moscowButtonOutlet: UIButton!
    
    
    var internetConnection = true
    var selectedCityName: String?
    
    var petersburgcache: Results<PetersburgCache>?
    var moscowCache: Results<MoscowCache>?
    
    var weatherManager = WeatherManager()
    var weatherModel: [WeatherModel]? = [WeatherModel]()
    
    @IBOutlet weak var weatherConditionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "WeatherTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
        weatherManager.weatherManagerDelegate = self
        
        
    }
    
    @IBAction func PetersburgPressed(_ sender: UIButton) {
        moscowButtonOutlet.isSelected = false
        PetersburgButtonOutlet.isSelected = true
        
        let cityName = "Petersburg"
        weatherManager.fetchWeather(weatherURL: Constants.petersburgUrl, city: cityName)
        
        
    }
    @IBAction func moscowPressed(_ sender: UIButton) {
        moscowButtonOutlet.isSelected = true
        PetersburgButtonOutlet.isSelected = false
        
        let cityName = "Moscow"
        weatherManager.fetchWeather(weatherURL: Constants.moscowUrl, city: cityName)
        
    }
    
}


//MARK: - UITableViewDataSource methods
extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if internetConnection{
           
            return weatherModel?.count ?? 0
        }else{
            return petersburgcache?.count ?? moscowCache?.count ?? 0
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
     
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! WeatherTableViewCell
        
        if internetConnection == false {
            if self.selectedCityName == "Petersburg" {
                if let itemcache = petersburgcache{
                    if !itemcache.isEmpty{
                        cell.cellDegreeLabel.text = itemcache[indexPath.row].dailyTemp
                        cell.cellWeatherImage.image = UIImage(systemName: itemcache[indexPath.row].dailyWeathImage)
                        cell.dateLabel.text = itemcache[indexPath.row].date
                    }
                }
            }else {
                
                if let itemcache = moscowCache{
                    if !itemcache.isEmpty{
                        cell.cellDegreeLabel.text = itemcache[indexPath.row].dailyTemp
                        cell.cellWeatherImage.image = UIImage(systemName: itemcache[indexPath.row].dailyWeathImage)
                        cell.dateLabel.text = itemcache[indexPath.row].date
                        
                    }
                    
                }
                
            }
        }
        if weatherModel?.count != 0 {
            cell.cellDegreeLabel.text = weatherModel?[indexPath.row].dailyTempString
            cell.cellWeatherImage.image = UIImage(systemName: weatherModel?[indexPath.row].dailyWeatherImage ?? "")
            cell.dateLabel.text = weatherModel?[indexPath.row].dateString
        }
        
        
        
        return cell
    }
    
    
}

//MARK: - WeatherManagerDelegate Methods

extension ViewController: WeatherManagerDelegate{
    
    func didntUpdateWeather(using selectedCityName: String) {
        self.internetConnection = false
        
        self.selectedCityName = selectedCityName
        
        DispatchQueue.main.async {
            
            let realm = try! Realm()
            
            if selectedCityName == "Petersburg"{
                self.petersburgcache = realm.objects(PetersburgCache.self)
                self.tableView.reloadData()
                self.viewWeatherImage.image = UIImage(systemName: self.petersburgcache?[0].currentWeathImage ?? "")
                self.viewDegreeLabel.text = self.petersburgcache?[0].currentTemp
                self.weatherConditionLabel.text = self.petersburgcache?[0].weatherCondition


                
            }else if selectedCityName == "Moscow"{
                self.moscowCache = realm.objects(MoscowCache.self)
                self.tableView.reloadData()
                self.viewWeatherImage.image = UIImage(systemName: self.moscowCache?[0].currentWeathImage ?? "")
                self.viewDegreeLabel.text = self.moscowCache?[0].currentTemp
                self.weatherConditionLabel.text = self.moscowCache?[0].weatherCondition
                
            }
        }
    }
    
    
    
    func didUpdateWeather(with weatherModel: [WeatherModel]) {
        self.internetConnection = true
        
        DispatchQueue.main.async {
            
            self.weatherModel = weatherModel
            self.tableView.reloadData()
            
            self.viewWeatherImage.image = UIImage(systemName: weatherModel[0].currentWeathImage)
            self.viewDegreeLabel.text = weatherModel[0].currentTempString
            self.weatherConditionLabel.text = weatherModel[0].weatherCondition
            
            
        }
    }
    
    
    
}

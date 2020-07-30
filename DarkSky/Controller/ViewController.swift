//
//  ViewController.swift
//  DarkSky
//
//  Created by Ebubechukwu Dimobi on 30.07.2020.
//  Copyright © 2020 blazeapps. All rights reserved.
//

import UIKit

class ViewController: UIViewController  {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewWeatherImage: UIImageView!
    @IBOutlet weak var viewDegreeLabel: UILabel!
    @IBOutlet weak var PetersburgButtonOutlet: UIButton!
    @IBOutlet weak var moscowButtonOutlet: UIButton!
    
    var weatherManager = WeatherManager()
    var weatherModel: [WeatherModel]? = [WeatherModel]()
    
    @IBOutlet weak var weatherConditionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "WeatherTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
        weatherManager.weatherManagerDelegate = self
        
    }

    @IBAction func PetersburgPressed(_ sender: UIButton) {
        moscowButtonOutlet.isSelected = false
        PetersburgButtonOutlet.isSelected = true
        
        weatherManager.fetchWeather(weatherURL: Constants.petersburgUrl)
        
        
    }
    @IBAction func moscowPressed(_ sender: UIButton) {
        moscowButtonOutlet.isSelected = true
        PetersburgButtonOutlet.isSelected = false
        
        weatherManager.fetchWeather(weatherURL: Constants.moscowUrl)
        
    }
    
}


//MARK: - UITableViewDataSource methods
extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return weatherModel?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! WeatherTableViewCell
        
        if weatherModel != nil{
            cell.cellDegreeLabel.text = weatherModel?[indexPath.row].dailyTempString
            cell.cellWeatherImage.image = UIImage(systemName: weatherModel?[indexPath.row].dailyWeatherImage ?? "")
            cell.dateLabel.text = weatherModel?[indexPath.row].dateString
        }
        
        return cell
    }
    
    
}

//MARK: - WeatherManagerDelegate Methods

extension ViewController: WeatherManagerDelegate{
    
    func didUpdateWeather(with weatherModel: [WeatherModel]) {
        DispatchQueue.main.async {
            
            self.weatherModel = weatherModel
            self.tableView.reloadData()
            
            self.viewWeatherImage.image = UIImage(systemName: weatherModel[0].currentWeathImage)
            self.viewDegreeLabel.text = weatherModel[0].currentTempString
            self.weatherConditionLabel.text = weatherModel[0].weatherCondition
            
            
        }
    }
    
    
    
}

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
    
    @IBOutlet weak var weatherConditionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "WeatherTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
        
    }

    @IBAction func PetersburgPressed(_ sender: UIButton) {
        moscowButtonOutlet.isSelected = false
        PetersburgButtonOutlet.isSelected = true
        
    }
    @IBAction func moscowPressed(_ sender: UIButton) {
        moscowButtonOutlet.isSelected = true
        PetersburgButtonOutlet.isSelected = false
        
    }
    
}



extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! WeatherTableViewCell
        
        return cell
    }
    
    
}

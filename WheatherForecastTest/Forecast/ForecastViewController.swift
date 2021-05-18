//
//  ForecastViewController.swift
//  WheatherForecastTest
//
//  Created by mac on 14.05.2021.
//

import UIKit
import RealmSwift


class WeatherRealm: Object {
    
    @objc dynamic var date = String()
    @objc dynamic var temp = Int()
    @objc dynamic var feelsLike = Int()
    
}

class ForecastViewController: UIViewController {

    // MARK: @IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var cityDaily: UILabel!
    
    // MARK: Internal vars
    let realm = try! Realm()
    var cityId: Int!
    var WeatherList: Results<WeatherRealm>!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        WeatherList = realm.objects(WeatherRealm.self)
        tableView.register(UINib(nibName: "ForecastCell", bundle: nil), forCellReuseIdentifier: "WeatherCell")
        cityId  = Persistance.shared.cityId
        getDailyWeather(cityId: cityId)
        
    }
    
    
    @IBAction func refresh(_ sender: Any) {
        cityId  = Persistance.shared.cityId
        getDailyWeather(cityId: cityId)
    }
    
    
    
    
    private func getDailyWeather(cityId: Int) {
        
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?id=\(cityId)&appid=dacda99f789972c741181a121168023c&units=metric"
        guard let url = URL(string: urlString) else { return }
        
        
        URLSession.shared.dataTask(with: url) { (data, responce, error) in
            guard let data = data else {return}
            guard error == nil else {return}
            
            do {
                let dailyWheather = try JSONDecoder().decode(DailyWheather.self, from: data)
                
                let daily = dailyWheather.list
                
                DispatchQueue.main.async {
                    try! self.realm.write {
                        self.realm.deleteAll()
                    }
                    
                    for items in daily {
                        let item = WeatherRealm()
                        item.date = items.dt_txt
                        item.temp = Int(items.main.temp)
                        item.feelsLike = Int(items.main.feels_like)
                        
                        try! self.realm.write() {
                            self.realm.add(item)
                        }
                    }
                    self.cityDaily.text = Persistance.shared.city
                    self.tableView.reloadData()
                    
                }
            }catch let error {
                print(error)
            }
        }.resume()
        
    }
}




// MARK: TableViewDelegate & DataSource

extension ForecastViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WeatherList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as! ForecastCell
        let item = WeatherList[indexPath.row]
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let theDate = formatter.date(from: item.date )
        let newDateFormater = DateFormatter()
        newDateFormater.dateFormat = "EEEE HH:mm:ss"
        let date = newDateFormater.string(from: theDate!)
        
        cell.dateLabel.text = date
        cell.tempLabel.text = "\(item.temp)"
        cell.feelsLikeLabel.text = "\(item.feelsLike)"
        
        return cell
    }
    
}

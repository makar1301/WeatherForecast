//
//  MainViewController.swift
//  WheatherForecastTest
//
//  Created by mac on 14.05.2021.
//

import UIKit
import CoreLocation



class MainViewController: UIViewController{
    
    static let shared = MainViewController()
    
    
    // MARK: @IBOutlets
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    
    private let locationManager = CLLocationManager()
    var imageCached = NSCache<NSString, UIImage>()
    var currentLocation: CLLocation!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabels()
        searchBar.delegate = self
        setupLocationManager()
    }
    
    
    
    private func setupLabels() {
        cityLabel.text = Persistance.shared.city
        tempLabel.text = "\(Persistance.shared.temp ?? 0)"
        commentLabel.text = Persistance.shared.comment
        descriptionLabel.text = Persistance.shared.description
        mainImage.image = getImage(from: Persistance.shared.icon ?? "")
    }
    
    
    private func setupLocationManager() {
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    
    
    public func getImage(from string: String) -> UIImage? {
        
        guard let url = URL(string: string)
        else {
            print("Unable to create URL")
            return nil
        }
        if let cachedImage = imageCached.object(forKey: url.absoluteString as NSString) {
            return cachedImage
        }
        var image: UIImage? = nil
        do {
            let data = try Data(contentsOf: url)
            
            image = UIImage(data: data)
            
            if let image = image {
                imageCached.setObject(image, forKey: url.absoluteString as NSString)
            }
            else {return nil}
        }
        catch {
            print(error.localizedDescription)
        }
        return image
    }
    
    
    func getWeather(lat: Double, lon: Double, city: String) {
        
        var urlString = ""
        if city != "" {
            urlString = "https://api.openweathermap.org/data/2.5/weather?q=" + city + "&appid=dacda99f789972c741181a121168023c&units=metric"
        } else {
            urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=dacda99f789972c741181a121168023c&units=metric"
        }
        
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, responce, error) in
            guard let data = data else {return}
            guard error == nil else {return}
            
            do {
                let currentWeather = try JSONDecoder().decode(Weather.self, from: data)
                print(currentWeather)
                
                DispatchQueue.main.async {
                    
                    Persistance.shared.cityId = currentWeather.id
                    Persistance.shared.city = currentWeather.name
                    Persistance.shared.temp = (Int(currentWeather.main.temp))
                    Persistance.shared.description = currentWeather.weather[0].description
                    
                    
                    
                    
                    
                    switch currentWeather.main.temp {
                    case -100...0: Persistance.shared.comment = "Температура меньше 0 градусов"
                    case 0...15 : Persistance.shared.comment = "Температура от 0 до 15 градусов"
                    case 15...100 : Persistance.shared.comment = "Температура выше 15 градусов"
                    default:
                        break
                    }
                    
                    
                    let string = "http://openweathermap.org/img/wn/" + currentWeather.weather[0].icon + "@2x.png"
                    Persistance.shared.icon = string
                    let image = self.getImage(from: string)
                    self.mainImage.image = image
                    
                    self.cityLabel.text = Persistance.shared.city
                    self.tempLabel.text = "\(Persistance.shared.temp ?? 0)" + "°C"
                    self.commentLabel.text = Persistance.shared.comment
                    self.descriptionLabel.text = Persistance.shared.description
                    
                }
                
                
            } catch let error {
                print(error)
            }
        }.resume()
        
        
        
        
        
        
    }
    
    
    
}

extension MainViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        
        guard let city = searchBar.text else { return }
        getWeather(lat: 0, lon: 0, city: city)
        searchBar.text = ""
        
    }
    
}

extension MainViewController: CLLocationManagerDelegate {
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.denied {
            let alert = UIAlertController(title: "Упс!", message: "Т.к вы не предоставили доступ к местоположению, воспользуйтесь поиском для выбора города", preferredStyle: .alert)
            let action = UIAlertAction(title: "Понял", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        let lat = locValue.latitude
        let lon = locValue.longitude
        getWeather(lat: lat, lon: lon, city: "")
        locationManager.stopUpdatingLocation()
        
    }
    
}

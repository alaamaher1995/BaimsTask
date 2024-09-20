//
//  ViewController.swift
//  DailyForecastApplication
//
//  Created by New User on 18/09/2024.
//

import UIKit

class ViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
   
    @IBOutlet weak var retryBtn: UIButton!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var cityName: UILabel!
    
    @IBOutlet weak var dropdownView: UIView!{
        didSet{
            dropdownView.layer.borderWidth = 1
            dropdownView.layer.borderColor = UIColor(red:222/255, green:225/255, blue:227/255, alpha: 1).cgColor
        }
    }
    
    @IBOutlet weak var cityPicker: UIPickerView!

    @IBAction func retryBtnAction(_ sender: Any) {
        print(selectedCity?.cityNameEn)
        fetchWeatherData(for: selectedCity?.cityNameEn ?? "")
    }
    
    var cities : [City] = []
    var selectedCity :City?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityPicker.delegate = self
        cityPicker.dataSource = self
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(openDropdownList))
        dropdownView.isUserInteractionEnabled = true
        dropdownView.addGestureRecognizer(gesture)
        
        
        // Load cities from the JSON file
        CityManager.shared.loadCities { [weak self] loadedCities in
            self?.cities = loadedCities
            self?.cityName.text = self?.cities[0].cityNameEn
            DispatchQueue.main.async {
            self?.cityPicker.reloadAllComponents()
            }
        }
       
           
        fetchWeatherData(for: selectedCity?.cityNameEn ?? "")

       
    }
    
    @objc func openDropdownList(sender:UITapGestureRecognizer) {
        self.cityPicker.isHidden = false
        cityPicker.reloadAllComponents()

    }
  



    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cities.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cities[row].cityNameEn
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCity = cities[row]
        cityName.text = selectedCity?.cityNameEn
        self.cityPicker.isHidden = true
        
        fetchWeatherData(for: selectedCity?.cityNameEn ?? "")
    }
    
    
    func fetchWeatherData(for city: String) {
            // Simulate lat/lon for the selected city
            let latLon = getLatLon(for: city)
            
            // Fetch data from the API
        WeatherAPIClient().fetchWeather(for: latLon.lat, longitude: latLon.lon) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        
                        let weather = response.list.first?.weather.first?.description
                        
                        self?.weatherLabel.text = "Weather: \(weather ?? "N/A")"
                        let weatherIconName = self?.getIconName(for: weather ?? "")
                        self?.iconImage.image = UIImage(named: weatherIconName ?? "")
                        
                        print(response.list.first?.weather.first?.description)
                        
                        if let data = try? JSONEncoder().encode(response) {
                            CacheManager.shared.saveWeatherData(data, forCity: city)
                        }
                        self?.retryBtn.isHidden = true
                    case .failure(_):
                        if let cachedData = CacheManager.shared.loadWeatherData(forCity: city),
                           let cachedResponse = try? JSONDecoder().decode(WeatherResponse.self, from: cachedData) {
                            self?.weatherLabel.text = "Cached Weather: \(cachedResponse.list.first?.weather.first?.description ?? "N/A")"
                            self?.retryBtn.isHidden = true
                            let weatherIconName = self?.getIconName(for: "fail")
                            self?.iconImage.image = UIImage(named: weatherIconName ?? "")
                        } else {
                            print("Error retrieving data")
                            self?.weatherLabel.text = "Error retrieving data"
                            self?.retryBtn.isHidden = false
                            let weatherIconName = self?.getIconName(for: "fail")
                            self?.iconImage.image = UIImage(named: weatherIconName ?? "")
                            
                        }
                    }
                }
            }
        }
    
    func getLatLon(for city: String) -> (lat: Double, lon: Double) {
            switch city {
            case "London": return (51.5074, -0.1278)
            case "New York": return (40.7128, -74.0060)
            case "Tokyo": return (35.6762, 139.6503)
            case "Paris": return (48.8566, 2.3522)
            default: return (0, 0)
            }
        }
    
    
    func getIconName(for description: String) -> String {
        switch description.lowercased() {
        case "light rain":
            return "lightRain"
        case "clear sky":
            return "ClearSky"
        case "broken clouds":
            return "lightRain"
        case "overcast clouds":
            return "overcastclouds"
        case "fail":
            return "NoInternet"
        default:
            return "NoInternet"
        }
    }
}


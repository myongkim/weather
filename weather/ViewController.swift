//
//  ViewController.swift
//  weather
//
//  Created by Isaac Kim on 12/28/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var cityNameLabel: UILabel!
    @IBOutlet var cityNameTextField: UITextField!
    @IBOutlet var weatherDescriptionLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var maxTempLabel: UILabel!
    @IBOutlet var minTempLabel: UILabel!
    @IBOutlet var weatherStackView: UIStackView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func tabFetchWeatherButton(_ sender: UIButton) {
        if let cityName = self.cityNameTextField.text {
            self.getCurrentWeather(cityName: cityName)
            self.view.endEditing(true)
        }
    }
    func configureView(weatherInformation: WeatherInformation) {
        self.cityNameLabel.text = weatherInformation.name
        if let weather = weatherInformation.weather.first {
            self.weatherDescriptionLabel.text = weather.description
        }
        self.tempLabel.text = "\(Int(weatherInformation.temp.temp - 273.15))°C"
        self.minTempLabel.text = "Lowest Temp: \(Int(weatherInformation.temp.minTemp - 273.15))°C"
        self.maxTempLabel.text = "Highest Temp: \(Int(weatherInformation.temp.maxTemp - 273.15))°C"
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Check", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func getCurrentWeather(cityName: String) {
        
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=f12b0398a849c20c1e6f84d3a449fd7b")
            else { return }
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { [weak self] data, response, error in
            let sucessRange = (200..<300)
            
            guard let data = data, error == nil else { return }
            let decoder = JSONDecoder()
            
            if let response = response as? HTTPURLResponse, sucessRange.contains(response.statusCode) {
                guard let weatherInformation = try? decoder.decode(WeatherInformation.self, from: data) else { return }
                DispatchQueue.main.async {
                    self?.weatherStackView.isHidden = false
                    self?.configureView(weatherInformation: weatherInformation)
                    debugPrint(weatherInformation)
                }
                } else {
                    guard let errorMessage = try? decoder.decode(ErrorMessage.self, from: data) else { return }
                    debugPrint(errorMessage)
                    DispatchQueue.main.async {
                        self?.showAlert(message: errorMessage.message)
                        debugPrint(errorMessage.message)
                        self?.weatherStackView.isHidden = true
                    }
                    
                }
        
            
            
        
        }.resume()
    }
    
}


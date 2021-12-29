//
//  WeatherInformation.swift
//  weather
//
//  Created by Isaac Kim on 12/28/21.
//

import Foundation

struct WeatherInformation: Codable {
    let weather: [Weather]
    let temp: Temp
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case weather
        case temp = "main"
        case name
    }
}

// key name and type has to be equal in the json to bring trhe information
struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
    
}

struct Temp: Codable {
    let temp: Double
    let feelsLike: Double
    let minTemp: Double
    let maxTemp: Double
    
    // the the JSON data's name is different this is how we map the data
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case minTemp = "temp_min"
        case maxTemp = "temp_max"
    }
    
}

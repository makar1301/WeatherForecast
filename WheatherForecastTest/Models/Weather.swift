//
//  Wheather.swift
//  WheatherForecastTest
//
//  Created by mac on 16.05.2021.
//

import Foundation


struct Weather: Decodable {
    
    let coord: Coordination
    let weather: [CurrentWeather]
    let main: Main
    let id: Int
    let name: String
}

struct Coordination: Decodable {
    let lon: Double
    let lat: Double
}

struct Main: Decodable {
    let temp: Double
}

struct CurrentWeather: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

//
//  ForecastWeather.swift
//  WheatherForecastTest
//
//  Created by mac on 17.05.2021.
//

import Foundation









struct DailyWheather: Decodable {
    let list: [List]
}
struct List: Decodable {
    let dt_txt: String
    let main: ForecastMain
}
struct ForecastMain: Decodable {
    let temp: Double
    let feels_like: Double
}

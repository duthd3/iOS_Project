//
//  WeatherData.swift
//  Clima
//
//  Created by yoonyeosong on 2023/11/11.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Codable { //Decodable + Encodable => Codable
    let name: String
    let main: Main
    let weather: [Weather]
    
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
    let id: Int
}

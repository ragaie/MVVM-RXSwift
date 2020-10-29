//
//  WeatherResult.swift
//  ParentTest
//
//  Created by Ragaie Alfy on 10/29/20.
//  Copyright © 2020 Ragaie Alfy. All rights reserved.
//
import UIKit

struct WeatherResult: Codable, Equatable {
    let main: MainModel? // for temprature
    let weather: [Weather]? // for icon, description
    let sys: SysModel?
    let visibility: Double?
    let wind: WindModel?
    var name: String?
}

extension WeatherResult {
    static var empty: WeatherResult {
        return WeatherResult(main: nil, weather: nil, sys: nil, visibility: nil, wind: nil, name: nil)
    }
}

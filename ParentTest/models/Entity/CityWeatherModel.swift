//
//  CityWeatherModel.swift
//  ParentTest
//
//  Created by Ragaie Alfy on 10/29/20.
//  Copyright © 2020 Ragaie Alfy. All rights reserved.
//


import Foundation
// Current weather bulks for city list
struct CityWeatherModel: Codable {
    var cnt: Int?
    var list: [WeatherResult]?
}

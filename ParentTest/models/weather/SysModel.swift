//
//  SysModel.swift
//  ParentTest
//
//  Created by Ragaie Alfy on 10/29/20.
//  Copyright © 2020 Ragaie Alfy. All rights reserved.
//

import Foundation

struct SysModel: Codable, Equatable {
    let timezone: Int64?
    let country: String?
    let sunrise: Double?
    let sunset: Double?
}

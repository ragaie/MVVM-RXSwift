//
//  CityListModel.swift
//  ParentTest
//
//  Created by Ragaie Alfy on 10/29/20.
//  Copyright © 2020 Ragaie Alfy. All rights reserved.
//

import Foundation

// swiftlint:disable identifier_name
struct CityListModel: Codable, Equatable {
    let id: Int?
    let name: String?
    let coord: Coord?
    let country: String?
}

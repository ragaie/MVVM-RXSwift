//
//  Weather.swift
//  ParentTest
//
//  Created by Ragaie Alfy on 10/29/20.
//  Copyright © 2020 Ragaie Alfy. All rights reserved.
//

import UIKit
// swiftlint:disable identifier_name
struct Weather: Codable, Equatable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

//
//  Response.swift
//  osia
//
//  Created by Daniel Khamsing on 5/2/20.
//  Copyright © 2020 Daniel Khamsing. All rights reserved.
//

import Foundation

struct Response: Codable {
    private enum CodingKeys: String, CodingKey {
        case apps = "projects"
        case categories
    }

    var apps: [App]
    var categories: [Category]
}

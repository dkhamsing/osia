//
//  Content.swift
//  osia
//
//  Created by Victor Peschenkov on 2/18/18.
//  Copyright © 2018 Daniel Khamsing. All rights reserved.
//

import Foundation

/// The model that corresponds to the content.json structure.
struct Content: Codable {
    enum CodingKeys: String, CodingKey {
        case apps = "projects"
        case categories
    }
    
    var apps: [App]
    var categories: [AppCategory]
}

//
//  App.swift
//  osia
//
//  Created by Victor Peschenkov on 2/18/18.
//  Copyright © 2018 Daniel Khamsing. All rights reserved.
//

import Foundation

struct App: Codable {
    private enum CodingKeys: String, CodingKey {
        case title
        case categoryIds = "category-ids"
        case dateAdded = "date_added"
        case description
        case screenshots
        case source
        case tags
    }
    
    var title: String?
    var categoryIds: [String]?
    var dateAdded: String?
    var description: String?
    var screenshots: [String]?
    var source: URL?
    var tags: [String]?
}

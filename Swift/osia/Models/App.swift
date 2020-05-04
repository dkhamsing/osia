//
//  App.swift
//  osia
//
//  Created by Victor Peschenkov on 2/18/18.
//  Copyright © 2018 Daniel Khamsing. All rights reserved.
//

import Foundation

struct App: Codable {
    enum CodingKeys: String, CodingKey {
        case title
        case categoryIds = "category-ids"
        case dateAdded = "date_added"
        case description
        case itunes
        case screenshots
        case source
        case stars
        case tags
    }
    
    var title: String?
    var categoryIds: [String]?
    var dateAdded: String?
    var description: String?
    var itunes: URL?
    var screenshots: [String]?
    var source: URL?
    var stars: Int?
    var tags: [String]?
}

extension App {
    private struct Constant {
        static let archive = "archive"
    }

    /// Returns a boolean value that indicates whether the app is archived or not.
    var isArchived: Bool {
        return self.tags?.contains(Constant.archive) == true
    }   
}

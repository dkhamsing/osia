//
//  AppCategory.swift
//  osia
//
//  Created by Victor Peschenkov on 2/18/18.
//  Copyright © 2018 Daniel Khamsing. All rights reserved.
//

import Foundation

/// The model that corresponds to the app category structure.
struct AppCategory: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case parent
        case apps
        case children
    }
    
    var id: String?
    var title: String?
    var description: String?
    var parent: String?
    var apps: [App]? = nil
    var children: [AppCategory]?
    
    /// Returns a boolean value that indicates whether the
    /// category has parent or not.
    func isParent() -> Bool {
        return parent == nil
    }
}

extension AppCategory: DisplayInterface {
    var isCategory: Bool {
        return true
    }
}

//
//  App.swift
//  osia
//
//  Created by Victor Peschenkov on 2/18/18.
//  Copyright © 2018 Daniel Khamsing. All rights reserved.
//

import Foundation

/// The model that corresponds to the app structure.
struct App: Codable {
    enum CodingKeys: String, CodingKey {
        case title
        case categoryIds = "category-ids"
        case description = "description"
        case itunes
        case screenshots
        case source
        case stars
        case tags
    }
    
    var title: String?
    var categoryIds: [String]?
    var description: String?
    var itunes: URL?
    var screenshots: [URL]?
    var source: URL?
    var stars: Int?
    var tags: [String]?
}

extension App {
    private struct Constants {
        static let archive = "archive"
        static let swift = "swift"
    }
    
    /// Returns a boolean value that indicates whether the app is
    /// written in Swift or not.
    func isSwift() -> Bool {
        return self.tags?.contains(Constants.swift) == true
    }
    
    /// Returns a boolean value that indicates whether the app is
    /// archived or not.
    func isArchive() -> Bool {
        return self.tags?.contains(Constants.archive) == true
    }
    
    /// Returns a boolean value that indicates whether the app is
    /// uploaded to AppStore or not.
    func isAppStore() -> Bool {
        return self.itunes != nil
    }
}

extension App: DisplayInterface {
    var isCategory: Bool {
        return true
    }
}

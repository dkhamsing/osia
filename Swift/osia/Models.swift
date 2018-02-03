//
//  Models.swift
//  osia
//
//  Created by Daniel on 9/6/17.
//  Copyright © 2017 Daniel Khamsing. All rights reserved.
//

import Foundation

/// Display protocol.
protocol Display {
    var isCategory: Bool { get }
    var title: String? { get }
}

/// App struct.
struct App: Display {
    
    var isCategory = false
    var title: String?
    
    var categoryIds: [String]?
    var descr: String?
    var itunes: URL?
    var screenshots: [URL]?
    var source: URL?
    var stars: Int?
    var tags: [String]?
    
//    not used
//    func isAppStore() -> Bool {
//        return self.itunes != nil
//    }
    
    func isArchive() -> Bool {
        return self.tags?.contains(Constants.archive) == true
    }
    
    func isSwift() -> Bool {
        return self.tags?.contains(Constants.swift) == true
    }
    
    private struct Constants {
        static let archive = "archive"
        static let swift = "swift"
    }
}

/// App category struct.
struct AppCategory: Display {
    var isCategory = true
    var title: String?
    
    var id: String?
    var description: String?
    var parent: String?
    var apps: [App]?
    var children: [AppCategory]?
    
    func isParent() -> Bool {
        return parent == nil
    }   
}

//
//  Category.swift
//  osia
//
//  Created by Daniel Khamsing on 5/2/20.
//  Copyright © 2020 Daniel Khamsing. All rights reserved.
//

import Foundation

struct Category: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case parent
        case apps
        case categories
    }

    var id: String?
    var title: String?
    var description: String?
    var parent: String?
    var apps: [App]? 
    var categories: [Category]?
}

extension Category {
    /// Returns a boolean value that indicates whether the has a parent.
    var isParent: Bool {
        return parent == nil
    }

    var list: [Any] {
        var list: [Any] = categories ?? []

        guard let apps = apps else { return list }

        for a in apps {
            list.append(a)
        }

        return list
    }
}

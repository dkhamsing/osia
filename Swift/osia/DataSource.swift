//
//  DataSource.swift
//  osia
//
//  Created by Daniel Khamsing on 2/3/18.
//  Copyright © 2018 Daniel Khamsing. All rights reserved.
//

import Foundation

struct DataSource {
    /// Create data source from URL.
    /// - Parameters:
    ///   - url: URL.
    ///   - completion: Completion handler.
    static func Create(url: String, completion: @escaping (Result<Category, JsonError>) -> Void ) {
        guard let url = URL(string: url) else {
            print("Error \(JsonError.url.rawValue)")
            completion(.failure(.url))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let data = data,
                let response = try? JSONDecoder().decode(Response.self, from: data),
                let root = CreateRoot(response: response) else {
                    print("Error \(JsonError.datasource.rawValue)")
                    completion(.failure(.datasource))
                    return
            }

            completion(.success(root))
        }.resume()
    }
}

enum JsonError: String, Error {
    case datasource = "Error creating data source"
    case url = "Error with URL"
}

private extension DataSource {
    /// Parse JSON response into app model.
    /// - Parameter response: JSON response.
    /// - Returns: Root `Category` item.
    static func CreateRoot(response: Response) -> Category? {
        let apps = response.apps.filter { $0.isArchived == false }

        var parentCategories: [Category] = []
        var childrenCategories: [Category] = []
        var categoryNames: Set<String> = Set()
        for var c in response.categories {
            c.apps = apps
                .filter { $0.categoryIds?.contains(c.id ?? "") ?? false }
                .sorted { $0.title?.lowercased() ?? "" < $1.title?.lowercased() ?? "" }

            if c.isParent {
                parentCategories.append(c)
                categoryNames.insert(c.id ?? "")
            }
            else {
                if c.apps?.count ?? 0 > 0 {
                childrenCategories.append(c)
                }
            }
        }

        var categories: [Category] = []
        for c in parentCategories {
            if categoryNames.contains(c.id ?? "") { // has sub categories
                var category = c
                category.categories = childrenCategories.filter { $0.parent == c.id }
                categories.append(category)
            }
            else {
                categories.append(c)
            }
        }

        let root = Category(categories: categories)
        return root
    }
}

private extension App {
    struct Constant {
        static let archive = "archive"
    }

    /// Returns a boolean value that indicates whether the app is archived or not.
    var isArchived: Bool {
        return self.tags?.contains(Constant.archive) == true
    }
}

private extension Category {    
    /// Returns a boolean value that indicates whether the category has a parent.
    var isParent: Bool {
        return parent == nil
    }
}

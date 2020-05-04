//
//  DataSource.swift
//  osia
//
//  Created by Daniel Khamsing on 2/3/18.
//  Copyright © 2018 Daniel Khamsing. All rights reserved.
//

import UIKit

struct DataSource {
    /// Create data source from URL.
    /// - Parameters:
    ///   - url: URL.
    ///   - completion: Completion handler.
    static func Create(url: String, completion: @escaping (Result<Category, JsonError>) -> Void ) {
        guard let url = URL(string: url) else {
            print("Error: creating endpoint")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completion(.failure(.conversionFailed))
                return
            }

            guard let data = data else {
                completion(.failure(.noData))
                return
            }

            if let response = try? JSONDecoder().decode(Response.self, from: data) {
                if let root = Parse(response: response) {
                    completion(.success(root))
                }
            }
            else {
                completion(.failure(.conversionFailed))
            }
        }.resume()
    }
}

enum JsonError: String, Error {
    case noData = "Error: no data"
    case conversionFailed = "Error: conversion from JSON failed"
}

private extension DataSource {
    /// Parse JSON response into app model.
    /// - Parameter response: JSON response.
    /// - Returns: Root `Category` object.
    static func Parse(response: Response) -> Category? {
        let apps = GenerateAppsDictionary(apps: response.apps)
        let root = GenerateRoot(apps: apps, categories: response.categories)
        return root
    }

    ///  Generate dictionary with category name key, and apps values.
    /// - Parameters:
    ///   - apps: `App` dictionary.
    ///   - filterArchived: Whether to filter archived apps.
    /// - Returns: Dictionary with category name key, and apps values.
    static func GenerateAppsDictionary(apps: [App], filterArchived: Bool = true) -> [String: [App]] {
        var apps = apps

        if filterArchived {
            apps = apps.filter { $0.isArchived == false }
        }

        var items: [String: [App]] = [:]
        for app in apps {
            if let categoryIDs = app.categoryIds {
                for id in categoryIDs {
                    if items[id] == nil {
                        items[id] = [app]
                    }
                    else {
                        var list = items[id] as [App]?
                        list?.append(app)
                        items[id] = list
                    }
                }
            }
        }
        return items
    }

    /// Generate the data source `Category` root object.
    /// - Parameters:
    ///   - apps: `App` dictionary.
    ///   - categories: `Category` list.
    /// - Returns: `Category` root object.
    static func GenerateRoot(apps: [String: [App]], categories: [Category]) -> Category {
        var children: [Category] = []
        var generatedCategories: [Category] = []
        for var category in categories {
            if let id = category.id {
                category.apps = apps[id] ?? []
                category.apps = category.apps?.sorted { $0.title?.lowercased() ?? "" < $1.title?.lowercased() ?? "" }
            }
            
            if category.isParent {
                generatedCategories.append(category)
            }
            else {
                children.append(category)
            }
        }
    
        for child in children {
            generatedCategories = Category.Insert(child: child, list: generatedCategories)
        }
        
        var root = Category()
        root.categories = generatedCategories.sorted { $0.title ?? "" < $1.title ?? "" }
        return root
    }
}

private extension Category {
    static func Insert(child: Category, list: [Category]) -> [Category] {
        guard let index = list.firstIndex(where: { $0.id == child.parent }) else { return list }
        
        var categories = list[index]
        if categories.categories != nil {
            categories.categories?.append(child)
        }
        else {
            categories.categories = [child]
        }

        var updated = list
        updated[index] = categories
        return updated
    }
}

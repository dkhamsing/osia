//
//  DataSource.swift
//  osia
//
//  Created by Daniel on 2/3/18.
//  Copyright © 2018 Daniel Khamsing. All rights reserved.
//

import UIKit

final class DataSource {
    
    /// Create data source from endpoint.
    ///
    /// - parameters:
    ///   - url: Endpoint URL.
    ///   - completion: Completion block.
    static func create(url: String, completion: @escaping (_: AppCategory) -> Void ) {
        guard let endpoint = URL(string: url) else {
            print("Error: creating endpoint")
            return
        }
        
        URLSession.shared.dataTask(with: endpoint) { (data, response, error) in
            do {
                guard let data = data else {
                    throw JsonError.noData
                }
                
                let decoder = JSONDecoder()
                guard let content = try? decoder.decode(Content.self, from: data) else {
                    throw JsonError.conversionFailed
                }
                
                if let root = parse(content: content) {
                    completion(root)
                }
            } catch let error as JsonError {
                print(error.rawValue)
            } catch let error as NSError {
                print(error.debugDescription)
            }
            }.resume()
    }
    
}

private extension DataSource {
    enum JsonError: String, Error {
        case noData = "Error: no data"
        case conversionFailed = "Error: conversion from JSON failed"
    }
    
    /// Parse JSON into app model.
    ///
    /// - parameter json: JSON retrieved from endpoint.
    /// - returns: `AppCategory` model object.
    static func parse(content: Content) -> AppCategory? {
        let apps = generateMapping(apps: content.apps)
        let root = generateRoot(apps: apps, categories: content.categories)
        return root
    }
    
    static func generateMapping(apps: [App]) -> [String: [App]] {
        var items = [String: [App]]()
        for app in apps {
            if !app.isArchive() {
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
        }
        return items
    }
    
    static func generateRoot(apps: [String: [App]], categories: [AppCategory]) -> AppCategory {
        var children = [AppCategory]()
        var generatedCategories = [AppCategory]()
        for var category in categories {
            if let id = category.id {
                category.apps = apps[id] ?? []
                category.apps = category.apps?.sorted { $0.title?.lowercased() ?? "" < $1.title?.lowercased() ?? "" }
            }
            
            if category.isParent() {
                generatedCategories.append(category)
            }
            else {
                children.append(category)
            }
        }
    
        for child in children {
            generatedCategories = AppCategory.insert(child: child, list: generatedCategories)
        }
        
        var root = AppCategory()
        root.children = generatedCategories.sorted { $0.title ?? "" < $1.title ?? "" }
        return root
    }
}

private extension AppCategory {
    static func insert(child: AppCategory, list: [AppCategory]) -> [AppCategory] {
        if let index = list.index(where: { $0.id == child.parent }) {
            var categories = list[index]
            if categories.children != nil {
                categories.children?.append(child)
            }
            else {
                categories.children = [child]
            }
            
            var updated = list
            updated[index] = categories
            return updated
        }
        return list
    }
}

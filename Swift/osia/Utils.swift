//
//  Utils.swift
//  osia
//
//  Created by Daniel on 8/10/17.
//  Copyright © 2017 Daniel Khamsing. All rights reserved.
//

import UIKit

/// Miscellaneous helpers.
class Utils {
    enum JsonError: String, Error {
        case noData = "Error: no data"
        case conversionFailed = "Error: conversion from JSON failed"
    }
    
    /// Fetch JSON
    ///
    /// - parameters:
    ///   - url: Endpoint URL
    ///   - completion: Completion block.
    class func fetchJsonFeed(url: String, completion: @escaping (_: AppCategory) -> Void ) {
        guard let endpoint = URL(string: url) else {
            print("Error: creating endpoint")
            return
        }
        URLSession.shared.dataTask(with: endpoint) { (data, response, error) in
            do {
                guard let data = data else {
                    throw JsonError.noData
                }
                
                guard let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any] else {
                    throw JsonError.conversionFailed
                }
                
                if let root = parse(json: json) {
                    completion(root)
                }                
            } catch let error as JsonError {
                print(error.rawValue)
            } catch let error as NSError {
                print(error.debugDescription)
            }
            }.resume()
    }
    
    /// Parse JSON into app model.
    ///
    /// - parameter json: JSON retrieved from endpoint.
    /// - returns: `AppCategory` model object.
    class func parse(json: [String: Any]) -> AppCategory? {
        guard let categories = json["categories"] as? [[String: Any]],
            let apps = json["projects"] as? [[String: Any]] else {return nil}
        
        var items = [String: Array<App>]()
        
        do {
            let keys = App.Constants()
            
            for dictionary in apps {
                var j = App()
                
                j.categoryIds = dictionary[keys.categoryIds] as? [String]
                j.descr = dictionary[keys.description] as? String
                if let itunes = dictionary[keys.itunes] as? String {
                    j.itunes = URL(string:itunes)
                }
                if let screenshots = dictionary[keys.screenshots] as? [String] {
                    j.screenshots = screenshots.flatMap { URL(string: $0) }
                }
                if let source = dictionary[keys.source] as? String {
                    j.source = URL(string:source)
                }
                j.stars = dictionary[keys.stars] as? Int
                j.tags = dictionary[keys.tags] as? [String]
                j.title = dictionary[keys.title] as? String
                
                if !j.isArchive() {
                    if let cids = j.categoryIds {
                        for id in cids {
                            if items[id] == nil {
                                items[id] = [j]
                            }
                            else {
                                var list = items[id] as [App]?
                                list?.append(j)
                                
                                items[id] = list
                            }
                        }
                    }
                    
                }
            }
        }
        
        var cats = [AppCategory]()
        var children = [AppCategory]()
        
        do {
            let keys = AppCategory.Constants()
            
            for dictionary in categories {
                var c = AppCategory()
                
                c.id = dictionary[keys.id] as? String
                c.description = dictionary[keys.description] as? String
                c.title = dictionary[keys.title] as? String
                c.parent = dictionary[keys.parent] as? String
                
                if let id = c.id {
                    c.apps = items[id] ?? []
                    c.apps = c.apps?.sorted {$0.title?.lowercased() ?? "" < $1.title?.lowercased() ?? ""}
                }
                
                if c.isParent() {
                    cats.append(c)
                }
                else {
                    children.append(c)
                }
            }
        }
        
        for child in children {
            cats = AppCategory.insert(child: child, list: cats)
        }
        
        var root = AppCategory()
        root.children = cats.sorted {$0.title ?? "" < $1.title ?? ""}
        
        return root
    }
    
}

private extension App {
    struct Constants {
        let categoryIds = "category-ids"
        let description = "description"
        let itunes = "itunes"
        let screenshots = "screenshots"
        let source = "source"
        let stars = "stars"
        let tags = "tags"
        let title = "title"
    }
}

private extension AppCategory {
    static func insert(child: AppCategory, list: [AppCategory]) -> [AppCategory] {
        if let index = list.index(where: { (item) -> Bool in
            item.id == child.parent
        }) {
            var cat = list[index]
            
            if (cat.children) != nil {
                cat.children?.append(child)
            }
            else {
                cat.children = [child]
            }
            
            var updated = list
            
            updated[index] = cat
            
            return updated
        }
        
        return list
    }
    
    struct Constants {
        let id = "id"
        let description = "description"
        let title = "title"
        let parent = "parent"
    }
}

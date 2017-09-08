//
//  CategoryController.swift
//  osia
//
//  Created by Daniel Khamsing on 9/6/17.
//  Copyright © 2017 Daniel Khamsing. All rights reserved.
//

import UIKit

protocol SelectDelegate {
    func didSelectApp(_ app: App)
    func didSelectCategory(_ category: AppCategory)
}

class CategoryController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var tableView = UITableView()
    var category = AppCategory()
    var delegate: SelectDelegate?
    
    let cellApp = "cellApp"
    let cellCategory = "cellCategory"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let f = view.frame
        tableView.frame = f
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellApp)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellCategory)
    }
}

/// Table view
extension CategoryController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category.dataSource().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var c = UITableViewCell()
        
        if let item = category.dataSource()[indexPath.row] as? Display {
            if let i = item as? App {
                c = UITableViewCell.init(style: .subtitle, reuseIdentifier: cellApp)
                c.detailTextLabel?.text = i.descr
                
            }
            else if let i = item as? AppCategory {
                let value = i.dataSource().count
                
                c = UITableViewCell.init(style: .value1, reuseIdentifier: cellCategory)
                let count = "\(value)"
                c.detailTextLabel?.text = count
            }
            
            c.detailTextLabel?.textColor = UIColor.gray
            c.textLabel?.text = item.title
            c.accessoryType = item.isCategory ? .disclosureIndicator : .none
        }
        
        return c
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let item = category.dataSource()[indexPath.row] as? Display {
            if let app = item as? App {
                delegate?.didSelectApp(app)
            }
            else if let cat = item as? AppCategory {
                delegate?.didSelectCategory(cat)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}

/// Table data source
extension AppCategory {
    fileprivate func dataSource() -> [Any] {
        var list: [Any] = children ?? []
        
        if let apps = apps {
            for a in apps {
                list.append(a)
            }
        }
        
        return list
    }
}

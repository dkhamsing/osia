//
//  Coordinator.swift
//  osia
//
//  Created by Daniel Khamsing on 9/5/17.
//  Copyright © 2017 Daniel Khamsing. All rights reserved.
//

import UIKit
import SafariServices

final class Coordinator {
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let v = CategoryController()
        v.delegate = self
        v.title = Constants.title
        navigationController.pushViewController(v, animated: false)
        
        DataSource.create(url: Constants.url) { result in
            if case .success(let c) = result {
                v.category = c
                DispatchQueue.main.async {
                    v.tableView.reloadData()
                }
            }
        }
    }
}

private struct Constants {
    static let title = "OSIA"
    static let url = "https://raw.githubusercontent.com/dkhamsing/open-source-ios-apps/master/contents.json"
}

extension Coordinator: Selectable {
    func didSelectApp(_ app: App) {        
        if app.screenshots?.count ?? 0 > 0 {
            let s = ScreenshotsController()
            s.delegate = self
            s.sourceURL = app.source 
            s.screenshots = app.screenshots
            s.title = app.title
            navigationController.pushViewController(s, animated: true)
        }
        else {
            didSelectURL(app.source)
        }
    }
    
    func didSelectCategory(_ category: AppCategory) {
        let v = CategoryController()
        v.category = category
        v.delegate = self
        v.title = category.title
        navigationController.pushViewController(v, animated: true)
    }
}

extension Coordinator: URLTappable {
    func didSelectURL(_ url: URL?) {
        guard let u = url else { return }
        let s = SFSafariViewController.init(url: u)
        navigationController.present(s, animated: true, completion: nil)
    }
}

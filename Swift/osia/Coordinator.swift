//
//  Coordinator.swift
//  osia
//
//  Created by Daniel Khamsing on 9/5/17.
//  Copyright © 2017 Daniel Khamsing. All rights reserved.
//

import UIKit

final class Coordinator {
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let v = ListController()
        v.delegate = self
        v.title = Constant.title
        navigationController.pushViewController(v, animated: false)
        
        DataSource.Create(url: Constant.url) { result in
            guard case .success(let root) = result else { return }

            v.category = root
            DispatchQueue.main.async {
                v.reload()
            }
        }
    }
}

private struct Constant {
    static let title = "OSIA"
    static let url = "https://raw.githubusercontent.com/dkhamsing/open-source-ios-apps/master/contents.json"
}

extension Coordinator: Selectable {
    func didSelect(_ app: App) {
        guard app.hasScreenshots else {
            didSelect(app.source)
            return
        }

        let s = ScreenshotsController()
        s.delegate = self
        s.title = app.title
        s.sourceURL = app.source
        s.screenshots = app.screenshots

        navigationController.pushViewController(s, animated: true)
    }
    
    func didSelect(_ category: Category) {
        let v = ListController()
        v.delegate = self
        v.title = category.title
        v.category = category

        navigationController.pushViewController(v, animated: true)
    }

    func didSelect(_ url: URL?) {
        guard let url = url else { return }

        UIApplication.shared.open(url)
    }
}

private extension App {
    var hasScreenshots: Bool {
        return screenshots?.count ?? 0 > 0
    }
}

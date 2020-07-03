//
//  ListController.swift
//  osia
//
//  Created by Daniel Khamsing on 9/6/17.
//  Copyright © 2017 Daniel Khamsing. All rights reserved.
//

import UIKit

final class ListController: UIViewController {
    // Data
    var category = Category()
    var delegate: Selectable?

    // UI
    private var tableView = UITableView(frame: .zero, style: .insetGrouped)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.setup()
    }
}

private struct Constant {
    static let rowHeight: CGFloat = 55
}

extension ListController {
    func reload() {
        tableView.reloadData()
    }
}

private extension ListController {
    func setup() {
        let f = view.frame
        tableView.frame = f
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = Constant.rowHeight

        tableView.register(AppCell.self, forCellReuseIdentifier: AppCell.ReuseIdentifier)
        tableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.ReuseIdentifier)
    }
}

extension ListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = category.list[indexPath.row]

        if let cat = item as? Category {
            let c = tableView.dequeueReusableCell(withIdentifier: CategoryCell.ReuseIdentifier, for: indexPath) as! CategoryCell
            c.category = cat
            return c
        }

        guard let app = item as? App else { return UITableViewCell() }
        let c = tableView.dequeueReusableCell(withIdentifier: AppCell.ReuseIdentifier, for: indexPath) as! AppCell
        c.app = app

        return c
    }
}

extension ListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let item = category.list[indexPath.row]
        if let app = item as? App {
            delegate?.didSelect(app)
        }
        else if let cat = item as? Category {
            delegate?.didSelect(cat)
        }
    }
}

//
//  Selectable.swift
//  osia
//
//  Created by Daniel Khamsing on 5/2/20.
//  Copyright © 2020 Daniel Khamsing. All rights reserved.
//

import Foundation

protocol Selectable {
    func didSelect(_ app: App)
    func didSelect(_ category: Category)
    func didSelect(_ url: URL?)
}

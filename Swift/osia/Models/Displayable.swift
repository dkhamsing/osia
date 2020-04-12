//
//  Displayable.swift
//  osia
//
//  Created by Daniel on 4/12/20.
//  Copyright © 2020 Daniel Khamsing. All rights reserved.
//

import Foundation

/// Display protocol.
protocol Displayable {
    var title: String? { get }
    var isCategory: Bool { get }
}

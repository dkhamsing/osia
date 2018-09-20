//
//  DisplayInterface.swift
//  osia
//
//  Created by Victor Peschenkov on 2/18/18.
//  Copyright © 2018 Daniel Khamsing. All rights reserved.
//

import Foundation

/// Display protocol.
protocol DisplayInterface {
    var title: String? { get }
    var isCategory: Bool { get }
}

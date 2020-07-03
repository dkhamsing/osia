//
//  AppCell.swift
//  osia
//
//  Created by Daniel Khamsing on 5/2/20.
//  Copyright © 2020 Daniel Khamsing. All rights reserved.
//

import UIKit

final class AppCell: UITableViewCell {
    static let ReuseIdentifier = "AppCell"

    var app: App? {
        didSet {
            textLabel?.text = app?.title
            detailTextLabel?.text = app?.subtitle
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        textLabel?.text = nil
        detailTextLabel?.text = nil
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)

        textLabel?.numberOfLines = 0

        detailTextLabel?.numberOfLines = 0
        detailTextLabel?.textColor = .gray
    }

    required init?(coder: NSCoder) {
        self.init()
    }
}

private extension App {
    var subtitle: String? {
        var s: [String] = []

        s.safeAppend(s: description)
        s.safeAppend(s: tagDisplay)
        s.safeAppend(s: dateDisplay)

        return s.joined(separator: "\n")
    }
}

private extension App {
    var dateDisplay: String? {
        return dateAdded?.date?.yearDisplay ?? dateAdded
    }

    var tagDisplay: String? {
        guard
            let t = tags,
            t.count > 0 else { return nil }

        return t.joined(separator: " ")
    }
}

private extension Array {
    mutating func safeAppend(s: Element?) {
        guard let e = s else { return }
        self.append(e)
    }
}

private extension Date {
    var yearDisplay: String? {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year], from: self)

        guard let year = dateComponents.year else { return nil }
        return "\(year)"
    }
}

extension String {
    var date: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX

        dateFormatter.dateFormat = "MMM d yyyy"
        if let date = dateFormatter.date(from: self) {
            return date
        }

        dateFormatter.dateFormat = "MMM d, yyyy"
        if let date = dateFormatter.date(from: self) {
            return date
        }

        dateFormatter.dateFormat = "E MMM d HH:mm:ss yyyy Z"
        if let date = dateFormatter.date(from: self) {
            return date
        }

        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        if let date = dateFormatter.date(from: self) {
            return date
        }

        return nil
    }
}

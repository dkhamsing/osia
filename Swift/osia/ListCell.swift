//
//  AppCell.swift
//  osia
//
//  Created by Daniel Khamsing on 5/2/20.
//  Copyright © 2020 Daniel Khamsing. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {
    override func prepareForReuse() {
        super.prepareForReuse()

        imageView?.image = nil
        textLabel?.text = nil
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)

        accessoryType = .disclosureIndicator
        imageView?.tintColor = .systemGray
    }

    required init?(coder: NSCoder) {
        self.init()
    }
}

extension CategoryCell {
    func configure(_ i: Displayable) {
        guard let i = i as? AppCategory else { return }

        let count = i.dataSource.count
        detailTextLabel?.text = String(count)
        
        imageView?.image = i.image
        textLabel?.text = i.title
    }
}

class AppCell: UITableViewCell {
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

extension AppCell {
    func configure(_ item: Displayable) {
        guard let i = item as? App else { return }

        textLabel?.text = i.title
        detailTextLabel?.text = i.subtitle
    }
}

private extension App {
    var dateDisplay: String? {
        return dateAdded?.convertedToDate?.yearDisplay ?? dateAdded
    }

    var subtitle: String? {
        var s = ""
        if let desc = description {
            s = desc
        }

        if let date = dateDisplay {
            if s.count > 0 {
                s = "\(s)\n"
            }
            s = "\(s)\(date)"
        }

        if
            let t = tags,
            t.count > 0 {
            if s.count > 0 {
                s = "\(s)\n"
            }
            s = "\(s)\(t.joined(separator: " "))"
        }

        return s
    }
}

private extension AppCategory {
    var sfsymbol: String {
        guard let title = title?.lowercased() else { return "app" }

        switch(title) {
        case "apple tv":
            return "tv"
        case "bonus":
            return "sparkles"
        case "browser":
            return "desktopcomputer"
        case "calculator":
            return "sum"
        case "calendar":
            return "calendar"
        case "clock":
            return "clock"
        case "clone":
            return "doc.on.doc"
        case "color":
            return "circle.fill"
        case "communication":
            return "text.bubble"
        case "developer":
            return "command"
        case "education":
            return "textformat.abc"
        case "event":
            return "person.2"
        case "extension":
            return "slider.horizontal.3"
        case "files":
            return "doc"
        case "finance":
            return "dollarsign.circle"
        case "game", "emulator":
            return "gamecontroller"
        case "health":
            return "heart"
        case "home":
            return "house"
        case "misc":
            return "ellipsis"
        case "news":
            return "antenna.radiowaves.left.and.right"
        case "official":
            return "star"
        case "location":
            return "location"
        case "media":
            return "play.rectangle"
        case "reactive programming":
            return "arrow.right"
        case "sample":
            return "chevron.left.slash.chevron.right"
        case "scan":
            return "viewfinder"
        case "security":
            return "lock"
        case "social":
            return "bubble.left.and.bubble.right"
        case "shopping":
            return "bag"
        case "text":
            return "textformat"
        case "timer":
            return "timer"
        case "tasks":
            return "checkmark.circle"
        case "travel":
            return "airplane"
        case "weather":
            return "cloud.sun"
        default:
            return "app"
        }
    }

    var image: UIImage? {
        return UIImage(systemName: sfsymbol)
    }
}

private extension Date {
    var yearDisplay: String? {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year], from: self)

        guard let year = dateComponents.year ?? nil else { return nil }
        return "\(year)"
    }
}

extension String {
    var convertedToDate: Date? {
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

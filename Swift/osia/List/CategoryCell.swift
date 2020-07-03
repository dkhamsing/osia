//
//  CategoryCell.swift
//  osia
//
//  Created by Daniel Khamsing on 5/2/20.
//  Copyright © 2020 Daniel Khamsing. All rights reserved.
//

import UIKit

final class CategoryCell: UITableViewCell {
    static let ReuseIdentifier = "CategoryCell"

    var category: Category? {
        didSet {
            textLabel?.text = category?.title
            detailTextLabel?.text = category?.countDisplay
            imageView?.image = category?.image
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        textLabel?.text = nil
        detailTextLabel?.text = nil
        imageView?.image = nil
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

private extension Category {
    var countDisplay: String? {
        let count = list.count
        return String(count)
    }

    var image: UIImage? {
        return UIImage(systemName: sfsymbol)
    }
}

private extension Category {
    var sfsymbol: String {
        guard let title = title?.lowercased() else { return "app" }

        switch(title) {
        case "apple tv":
            return "tv"
        case "animoji":
            return "hare"
        case "audio":
            return "music.note"
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
            return "circle.lefthalf.fill"
        case "communication":
            return "text.bubble"
        case "content":
            return "doc.richtext"
        case "cryptocurrency":
            return "bitcoinsign.circle"
        case "developer", "github", "cocos2d", "spritekit", "researchkit", "appcelerator", "core data", "firebase", "flutter",
            "ionic", "parse", "react native", "realm", "swiftui", "viper", "xamarin":
            return "square.stack.3d.up"
        case "education":
            return "textformat.abc"
        case "event", "contact tracing":
            return "person.2"
        case "extension", "content blocking", "today":
            return "slider.horizontal.3"
        case "files":
            return "doc"
        case "finance":
            return "dollarsign.circle"
        case "game", "emulator":
            return "gamecontroller"
        case "gif":
            return "square.stack.3d.down.dottedline"
        case "health", "fitness":
            return "heart"
        case "home":
            return "house"
        case "misc":
            return "ellipsis"
        case "news", "hacker news", "news api", "rss":
            return "antenna.radiowaves.left.and.right"
        case "notes":
            return "doc.plaintext"
        case "official":
            return "star"
        case "password":
            return "pencil.and.ellipsis.rectangle"
        case "photo":
            return "photo"
        case "location":
            return "location"
        case "media":
            return "play.rectangle"
        case "reactive programming", "reactivecocoa", "rxswift":
            return "arrow.right"
        case "sample":
            return "chevron.left.slash.chevron.right"
        case "scan":
            return "viewfinder"
        case "security":
            return "lock"
        case "social", "mastodon":
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
        case "video":
            return "video"
        case "weather":
            return "cloud.sun"
        default:
            return "app"
        }
    }
}

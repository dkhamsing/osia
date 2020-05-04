//
//  ScreenshotCell.swift
//  osia
//
//  Created by Daniel Khamsing on 2/3/18.
//  Copyright © 2018 Daniel Khamsing. All rights reserved.
//

import UIKit

final class ScreenshotCell: UICollectionViewCell {
    var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

private extension ScreenshotCell {
    func setup() {
        imageView.frame = contentView.bounds
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imageView.contentMode = .scaleAspectFit
        
        self.contentView.addSubview(imageView)
    }
}

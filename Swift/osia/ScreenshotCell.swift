//
//  ScreenshotCell.swift
//  osia
//
//  Created by Daniel on 2/3/18.
//  Copyright © 2018 Daniel Khamsing. All rights reserved.
//

import UIKit

final class ScreenshotCell: UICollectionViewCell {
    var imageView = UIImageView()
    
    var url: URL? = nil {
        didSet {
            self.setImage(url: url)
        }
    }
    
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
    
    func setImage(url: URL?) {
        if let u = url {
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    let data = try Data.init(contentsOf: u)
                    
                    DispatchQueue.main.async {
                        self.imageView.image = UIImage.init(data:data)
                    }
                } catch {
                    print("Error getting image data.")
                }
            }
        }
    }
}

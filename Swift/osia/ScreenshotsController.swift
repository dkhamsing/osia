//
//  ScreenshotsController.swift
//  osia
//
//  Created by Daniel Khamsing on 9/6/17.
//  Copyright © 2017 Daniel Khamsing. All rights reserved.
//

import UIKit

protocol SelectURL {
    func didSelectURL(_ url: URL?)
}

final class ScreenshotsController: UIViewController {
    var collectionView: UICollectionView?
    var delegate: SelectURL?
    var screenshots: [URL]?
    var didSelectSourceUrl: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        collectionView?.collectionViewLayout.invalidateLayout()
    }
}

private extension ScreenshotsController {
    @objc func github() {
        didSelectSourceUrl?()
    }
    
    func setup() {
        // iOS 11
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
        
        // Bar button
        let barButton = UIBarButtonItem.init(title: Constants.barButtonTitle, style: .plain, target: self, action: #selector(github))
        self.navigationItem.rightBarButtonItem = barButton
        
        // Collection
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: layout)
        
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.register(ScreenshotCell.self, forCellWithReuseIdentifier: Constants.cellId)
        
        self.view.addSubview(collectionView)
        
        self.collectionView = collectionView
    }
}

private struct Constants {
    static let cellId = "cell"
    static let barButtonTitle = "GitHub"
    static let inset: CGFloat = 170
}

extension ScreenshotsController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return screenshots?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let u = screenshots?[indexPath.row]
        delegate?.didSelectURL(u)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let url = screenshots?[indexPath.row]
        
        let c = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellId, for: indexPath) as! ScreenshotCell
        c.url = url
        
        return c
    }
}

extension ScreenshotsController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = self.view.bounds.size
        size.height -= Constants.inset
        return size
    }    
}

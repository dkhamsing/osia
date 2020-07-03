//
//  ScreenshotsController.swift
//  osia
//
//  Created by Daniel Khamsing on 9/6/17.
//  Copyright © 2017 Daniel Khamsing. All rights reserved.
//

import UIKit

final class ScreenshotsController: UIViewController {
    // Data
    var delegate: Selectable?
    var sourceURL: URL?
    var screenshots: [String]?

    // UI
    private var collectionView: UICollectionView?
    private let spinner = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        collectionView?.collectionViewLayout.invalidateLayout()
    }
}

private struct Constant {
    static let cellId = "cell"
    static let barButtonTitle = "GitHub"
    static let inset: CGFloat = 170
}

private extension ScreenshotsController {
    @objc func github() {
        delegate?.didSelect(sourceURL)
    }
    
    func setup() {
        navigationItem.largeTitleDisplayMode = .never

        // Bar button
        let barButton = UIBarButtonItem(title: Constant.barButtonTitle, style: .plain, target: self, action: #selector(github))
        self.navigationItem.rightBarButtonItem = barButton


        // Collection
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.register(ScreenshotCell.self, forCellWithReuseIdentifier: Constant.cellId)
        
        self.view.addSubview(collectionView)
        
        self.collectionView = collectionView

        // Spinner
        spinner.color = .white

        spinner.frame = view.bounds
        self.view.addSubview(spinner)
    }
}

extension ScreenshotsController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return screenshots?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard
            let unwrapped = screenshots?[indexPath.row],
            let actualUrl = URL(string: unwrapped) else { return }

        delegate?.didSelect(actualUrl)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let c = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.cellId, for: indexPath) as! ScreenshotCell

        guard
            let string = screenshots?[indexPath.row],
            let url = URL(string: string) else { return c }

        if c.imageView.image == nil {
            spinner.startAnimating()
        }
        
        url.getImage(completion: { (image) in
            c.imageView.image = image
            self.spinner.stopAnimating()
        })

        return c
    }
}

extension ScreenshotsController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = self.view.bounds.size
        size.height -= Constant.inset
        return size
    }    
}

private extension URL {
    func getImage(completion: @escaping (UIImage?)-> Void) {
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: self) else {
                completion(nil)
                return
            }
            DispatchQueue.main.async {
                completion(UIImage(data:data))
            }
        }
    }
}

// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import PodcastsGenresList

public final class GenresListViewController: UICollectionViewController {
    private var loader: GenresLoader?
    
    public convenience init(collectionViewLayout layout: UICollectionViewLayout, loader: GenresLoader) {
        self.init(collectionViewLayout: layout)
        self.loader = loader
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(load), for: .valueChanged)
        load()
    }
    
    @objc
    private func load() {
        collectionView.refreshControl?.beginRefreshing()
        loader?.load { [weak self] _ in
            self?.collectionView.refreshControl?.endRefreshing()
        }
    }
}

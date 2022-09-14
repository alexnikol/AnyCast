// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import PodcastsGenresList

public final class GenresListViewController: UICollectionViewController {
    private var loader: GenresLoader?
    private var collectionModel: [Genre] = []
    
    public convenience init(collectionViewLayout layout: UICollectionViewLayout, loader: GenresLoader) {
        self.init(collectionViewLayout: layout)
        self.loader = loader
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(load), for: .valueChanged)
        collectionView.register(GenreCell.self, forCellWithReuseIdentifier: String(describing: GenreCell.self))
        
        load()
    }
    
    @objc
    private func load() {
        collectionView.refreshControl?.beginRefreshing()
        loader?.load { [weak self] result in
            self?.collectionModel = (try? result.get()) ?? []
            self?.collectionView.reloadData()
            self?.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    public override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionModel.count
    }
    
    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = collectionModel[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: GenreCell.self), for: indexPath) as! GenreCell
        cell.nameLabel.text = model.name
        return cell
    }
}

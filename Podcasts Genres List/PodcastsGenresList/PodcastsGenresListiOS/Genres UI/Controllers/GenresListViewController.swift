// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import PodcastsGenresList

public final class GenresListViewController: UICollectionViewController {
    private var refreshController: GenresRefreshViewController?
    var collectionModel: [GenreCellController] = [] {
        didSet { collectionView.reloadData() }
    }
    
    convenience init(collectionViewLayout layout: UICollectionViewLayout, refreshController: GenresRefreshViewController) {
        self.init(collectionViewLayout: layout)
        self.refreshController = refreshController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.refreshControl = refreshController?.view
        collectionView.register(GenreCell.self, forCellWithReuseIdentifier: String(describing: GenreCell.self))
            
        refreshController?.refresh()
    }
    
    public override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionModel.count
    }
    
    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return cellController(forRowAt: indexPath).view(collectionView, cellForItemAt: indexPath)
    }
    
    private func cellController(forRowAt indexPath: IndexPath) -> GenreCellController {
        return collectionModel[indexPath.row]
    }
}

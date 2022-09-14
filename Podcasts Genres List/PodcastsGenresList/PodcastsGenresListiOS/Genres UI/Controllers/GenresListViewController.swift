// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import PodcastsGenresList

public final class GenresListViewController: UICollectionViewController {
    private var refreshController: GenresRefreshViewController?
    private var collectionModel: [Genre] = []
    private var cellControllers: [IndexPath: GenreCellController] = [:]
    
    public convenience init(collectionViewLayout layout: UICollectionViewLayout, loader: GenresLoader) {
        self.init(collectionViewLayout: layout)
        self.refreshController = GenresRefreshViewController(genresLoader: loader)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.refreshControl = refreshController?.view
        collectionView.register(GenreCell.self, forCellWithReuseIdentifier: String(describing: GenreCell.self))
        
        refreshController?.onRefresh = { [weak self] genres in
            self?.collectionModel = genres
            self?.collectionView.reloadData()
        }
        
        refreshController?.refresh()
    }
    
    public override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionModel.count
    }
    
    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return cellController(forRowAt: indexPath).view(collectionView, cellForItemAt: indexPath)
    }
    
    private func cellController(forRowAt indexPath: IndexPath) -> GenreCellController {
        let model = collectionModel[indexPath.row]
        let cellController = GenreCellController(model: model)
        cellControllers[indexPath] = cellController
        return cellController
    }
}

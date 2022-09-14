// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import PodcastsGenresList

public final class GenresListViewController: UICollectionViewController {
    private var refreshController: GenresRefreshViewController?
    private var collectionModel: [Genre] = []
    
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
        let model = collectionModel[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: GenreCell.self), for: indexPath) as! GenreCell
        cell.nameLabel.text = model.name
        return cell
    }
}

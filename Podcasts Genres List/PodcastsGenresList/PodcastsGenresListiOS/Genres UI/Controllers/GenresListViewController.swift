// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit

public final class GenresListViewController: UICollectionViewController {
    private var refreshController: GenresRefreshViewController?
    var collectionModel: [GenreCellController] = [] {
        didSet { collectionView.reloadData() }
    }
    
    convenience init(refreshController: GenresRefreshViewController) {
        self.init(collectionViewLayout: UICollectionViewFlowLayout())
        self.refreshController = refreshController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureListView()
        
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
    
    private func configureListView() {
        collectionView.refreshControl = refreshController?.view
    }
}

// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit

public final class GenresListViewController: UICollectionViewController {
    
    private enum Defaults {
        enum Collection {
            static let sideSpacing: CGFloat = 16.0
            static let lineSpacing: CGFloat = 8.0
            static let perItemsSpacing: CGFloat = 8.0
            static let cellHeight: CGFloat = 40.0
        }
    }
    
    private var refreshController: GenresRefreshViewController?
    var collectionModel: [GenreCellController] = [] {
        didSet { collectionView.reloadData() }
    }
    
    public convenience init(refreshController: GenresRefreshViewController) {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Defaults.Collection.lineSpacing
        layout.minimumInteritemSpacing = Defaults.Collection.perItemsSpacing
        layout.sectionInset = .init(top: 0, left: Defaults.Collection.sideSpacing, bottom: 0, right: Defaults.Collection.sideSpacing)
        self.init(collectionViewLayout: layout)
        self.refreshController = refreshController
    }
    
    public func display(_ controllers: [GenreCellController]) {
        collectionModel = controllers
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureCollection(collectionView: collectionView)
        
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

extension GenresListViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - Defaults.Collection.perItemsSpacing - Defaults.Collection.sideSpacing * 2) / 2
        let height: CGFloat = Defaults.Collection.cellHeight
        return .init(width: width, height: height)
    }
}

private extension GenresListViewController {
    func configureCollection(collectionView: UICollectionView) {
        collectionView.refreshControl = refreshController?.view
    }
}

// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import LoadResourcePresenter
import SharedComponentsiOSModule

public final class GenresListViewController: UICollectionViewController {
    
    private enum Defaults {
        enum Collection {
            static let sideSpacing: CGFloat = 8.0
            static let lineSpacing: CGFloat = 8.0
            static let perItemsSpacing: CGFloat = 4.0
            static let cellHeight: CGFloat = 40.0
        }
    }
    
    private var refreshController: RefreshViewController?
    var collectionModel: [GenreCellController] = [] {
        didSet { collectionView.reloadData() }
    }
    
    public convenience init(refreshController: RefreshViewController) {
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
        let cellController = cellController(forRowAt: indexPath)
        return cellController.view(collectionView, cellForItemAt: indexPath)
    }
    
    private func cellController(forRowAt indexPath: IndexPath) -> GenreCellController {
        return collectionModel[indexPath.row]
    }
    
    public override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionModel[indexPath.row].didSelect()
    }
    
    public override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        collectionModel[indexPath.row].updateHighlight(true)
    }
    
    public override func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        collectionModel[indexPath.row].updateHighlight(false)
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

extension GenresListViewController: ResourceErrorView {
    public func display(_ viewModel: ResourceErrorViewModel) {}
}

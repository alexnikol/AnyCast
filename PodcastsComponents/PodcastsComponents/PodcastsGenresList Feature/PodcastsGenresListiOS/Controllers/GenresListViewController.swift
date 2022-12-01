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
        layout.sectionInsetReference = .fromSafeArea
        self.init(collectionViewLayout: layout)
        self.refreshController = refreshController
    }
    
    public func display(_ controllers: [GenreCellController]) {
        collectionModel = controllers
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView?.collectionViewLayout.invalidateLayout()
    }
        
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureCollection(collectionView: collectionView)
        
        refreshController?.refresh()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            
            guard let windowScene = UIApplication.shared.connectedScenes
                        .filter({ $0.activationState == .foregroundActive })
                        .compactMap({$0 as? UIWindowScene})
                        .first, let window = windowScene.windows.first else { return }
            
            print("window \(window.safeAreaInsets) \(window.layoutMargins)")
        })
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
        let cellSpaces = Defaults.Collection.perItemsSpacing + Defaults.Collection.sideSpacing * 2
        let safeAreaSpaces = collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right
        let width = (collectionView.bounds.width - safeAreaSpaces - cellSpaces) / 2
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

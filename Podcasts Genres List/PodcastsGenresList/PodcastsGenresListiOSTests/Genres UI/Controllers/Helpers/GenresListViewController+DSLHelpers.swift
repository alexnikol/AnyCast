// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import PodcastsGenresListiOS

extension GenresListViewController {
    func simulateUserInitiatedGenresReload() {
        collectionView.refreshControl?.simulatePullToRefresh()
    }
    
    var isShowinLoadingIndicator: Bool {
        return collectionView.refreshControl?.isRefreshing == true
    }
    
    private var genresSection: Int {
        return 0
    }
    
    func numberOfRenderedGenresViews() -> Int {
        return collectionView.numberOfItems(inSection: genresSection)
    }
    
    func genreView(at row: Int) -> UICollectionViewCell? {
        let ds = collectionView.dataSource
        let index = IndexPath(row: row, section: genresSection)
        return ds?.collectionView(collectionView, cellForItemAt: index)
    }
}

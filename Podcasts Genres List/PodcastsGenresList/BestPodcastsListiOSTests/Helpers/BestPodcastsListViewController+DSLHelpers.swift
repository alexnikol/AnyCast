// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import BestPodcastsListiOS

extension BestPodcastsListViewController {
    func simulateUserInitiatedPodcastsListReload() {
        tableView.refreshControl?.simulatePullToRefresh()
    }
    
    var isShowinLoadingIndicator: Bool {
        return tableView.refreshControl?.isRefreshing ?? false
    }
    
    private var podcastsSection: Int {
        return 0
    }
    
    func numberOfRenderedGenresViews() -> Int {
        return tableView.numberOfRows(inSection: podcastsSection)
    }
    
    func podcastView(at row: Int) -> UITableViewCell? {
        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: podcastsSection)
        return ds?.tableView(tableView, cellForRowAt: index)
    }
}

// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import PodcastsModuleiOS

extension ListViewController {
    
    func simulateUserInitiatedListReload() {
        tableView.refreshControl?.simulatePullToRefresh()
    }
    
    var isShowinLoadingIndicator: Bool {
        return tableView.refreshControl?.isRefreshing ?? false
    }
    
    func view(at row: Int, section: Int) -> UITableViewCell? {
        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: section)
        return ds?.tableView(tableView, cellForRowAt: index)
    }
    
    func headerView(at section: Int) -> UITableViewHeaderFooterView? {
        let delegate = tableView.delegate
        return delegate?.tableView?(tableView, viewForHeaderInSection: section) as? UITableViewHeaderFooterView
    }
}

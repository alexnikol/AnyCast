// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import PodcastsModuleiOS

extension ListViewController {
    
    func simulateUserInitiatedListReload() {
        tableView.refreshControl?.simulatePullToRefresh()
    }
    
    var isShowinLoadingIndicator: Bool {
        return tableView.refreshControl?.isRefreshing ?? false
    }
}

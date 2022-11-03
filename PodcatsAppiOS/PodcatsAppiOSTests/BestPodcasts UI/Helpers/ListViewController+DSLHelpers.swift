// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import BestPodcastsListiOS

extension ListViewController {
    func simulateUserInitiatedPodcastsListReload() {
        tableView.refreshControl?.simulatePullToRefresh()
    }
    
    @discardableResult
    func simulatePodcastImageViewVisible(at row: Int) -> PodcastCell? {
        return podcastView(at: row) as? PodcastCell
    }
    
    @discardableResult
    func simulatePodcastImageNotViewVisible(at row: Int) -> PodcastCell? {
        let view = simulatePodcastImageViewVisible(at: row)
        let delegate = tableView.delegate
        let index = IndexPath(row: row, section: podcastsSection)
        delegate?.tableView?(tableView, didEndDisplaying: view!, forRowAt: index)
        return view
    }

    func simulatePodcastImageViewNearVisible(at row: Int) {
        let ds = tableView.prefetchDataSource
        let indexPath = IndexPath(row: row, section: podcastsSection)
        ds?.tableView(tableView, prefetchRowsAt: [indexPath])
    }
    
    func simulatePodcastImageViewNotNearVisible(at row: Int) {
        simulatePodcastImageViewNearVisible(at: row)
        
        let ds = tableView.prefetchDataSource
        let indexPath = IndexPath(row: row, section: podcastsSection)
        ds?.tableView?(tableView, cancelPrefetchingForRowsAt: [indexPath])
    }
    
    var isShowinLoadingIndicator: Bool {
        return tableView.refreshControl?.isRefreshing ?? false
    }
    
    private var podcastsSection: Int {
        return 0
    }
    
    func numberOfRenderedPodcastsViews() -> Int {
        return tableView.numberOfRows(inSection: podcastsSection)
    }
    
    func podcastView(at row: Int) -> UITableViewCell? {
        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: podcastsSection)
        return ds?.tableView(tableView, cellForRowAt: index)
    }
}

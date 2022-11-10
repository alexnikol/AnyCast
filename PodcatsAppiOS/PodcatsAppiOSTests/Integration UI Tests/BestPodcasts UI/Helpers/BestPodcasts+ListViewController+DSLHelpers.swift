// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import PodcastsModuleiOS

extension ListViewController {
    
    @discardableResult
    func simulatePodcastImageViewVisible(at row: Int) -> PodcastCell? {
        return podcastView(at: row)
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
    
    func simulateTapOnPodcast(at row: Int) {
        let delegate = tableView.delegate
        let indexPath = IndexPath(row: row, section: podcastsSection)
        delegate?.tableView?(tableView, didSelectRowAt: indexPath)
    }
    
    private var podcastsSection: Int {
        return 0
    }
    
    func numberOfRenderedPodcastsViews() -> Int {
        return tableView.numberOfRows(inSection: podcastsSection)
    }
    
    func podcastView(at row: Int) -> PodcastCell? {
        return view(at: row, section: podcastsSection) as? PodcastCell
    }
}

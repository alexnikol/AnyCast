// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import PodcastsModuleiOS

extension ListViewController {
    private var episodesSection: Int {
        return 0
    }
    
    private var podcastHeaderSection: Int {
        return 0
    }
    
    func numberOfRenderedEpisodesViews() -> Int {
        return tableView.numberOfRows(inSection: episodesSection)
    }
    
    func episodeView(at row: Int) -> EpisodeCell? {
        return view(at: row, section: episodesSection) as? EpisodeCell
    }
    
    func podcastHeader() -> PodcastHeaderReusableView? {
        return headerView(at: podcastHeaderSection) as? PodcastHeaderReusableView
    }
    
    @discardableResult
    func simulatePodcastDetailsMainImageViewVisible() -> PodcastHeaderReusableView? {
        return headerView(at: podcastHeaderSection) as? PodcastHeaderReusableView
    }
}

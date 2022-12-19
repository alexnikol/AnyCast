// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import SharedComponentsiOSModule
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
    
    @discardableResult
    func simulatePodcastDetailsMainImageViewNotVisible() -> PodcastHeaderReusableView? {
        guard let headerView = simulatePodcastDetailsMainImageViewVisible() else { return nil }
        let delegate = tableView.delegate
        delegate?.tableView?(tableView, didEndDisplayingHeaderView: headerView, forSection: podcastHeaderSection)
        return headerView
    }
    
    func simulateTapOnEpisode(at row: Int) {
        let delegate = tableView.delegate
        let indexPath = IndexPath(row: row, section: episodesSection)
        delegate?.tableView?(tableView, didSelectRowAt: indexPath)
    }
}

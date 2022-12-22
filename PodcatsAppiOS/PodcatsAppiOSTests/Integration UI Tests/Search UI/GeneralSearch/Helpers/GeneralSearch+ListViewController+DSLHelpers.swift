// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import SharedComponentsiOSModule
import PodcastsModuleiOS
import SearchContentModuleiOS

extension ListViewController {
        
    // MARK: - Episodes
    
    private var searchEpisodesSection: Int {
        return 0
    }
            
    func numberOfRenderedSearchedEpisodesViews() -> Int {
        guard searchEpisodesSection + 1 <= tableView.numberOfSections else {
            return 0
        }
        return tableView.numberOfRows(inSection: searchEpisodesSection)
    }
    
    func searchEpisodeView(at row: Int) -> EpisodeCell? {
        return view(at: row, section: searchEpisodesSection) as? EpisodeCell
    }
    
    // MARK: - Podcasts
    
    private var searchPodcastsSection: Int {
        return 1
    }
    
    func numberOfRenderedSearchedPodcastsViews() -> Int {
        guard searchPodcastsSection + 1 <= tableView.numberOfSections else {
            return 0
        }
        return tableView.numberOfRows(inSection: searchPodcastsSection)
    }
    
    func searchPodcastView(at row: Int) -> SearchPodcastCell? {
        return view(at: row, section: searchPodcastsSection) as? SearchPodcastCell
    }
    
    // MARK: - Curated lists
    
    private var searchCuratedListSection: Int {
        return 2
    }
    
    func numberOfCuratedList() -> Int {
        guard tableView.numberOfSections > 1 else {
            return 0
        }
        return 2
    }
    
    func numberOfRenderedPodcastsInCuratedList(in section: Int) -> Int {
        return tableView.numberOfRows(inSection: section)
    }
        
    func searchPodcastCuratedListView(at row: Int, curatedListSection section: Int) -> SearchPodcastCell? {
        return view(at: row, section: section) as? SearchPodcastCell
    }
}

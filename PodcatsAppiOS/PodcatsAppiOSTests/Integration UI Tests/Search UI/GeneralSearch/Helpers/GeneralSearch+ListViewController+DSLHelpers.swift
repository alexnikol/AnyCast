// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import SharedComponentsiOSModule
import PodcastsModuleiOS

extension ListViewController {
        
    private var searchTermsSection: Int {
        return 0
    }
        
    func numberOfRenderedSearchedEpisodesViews() -> Int {
        return tableView.numberOfRows(inSection: searchTermsSection)
    }
    
    func searchEpisodeView(at row: Int) -> EpisodeCell? {
        return view(at: row, section: searchTermsSection) as? EpisodeCell
    }
}

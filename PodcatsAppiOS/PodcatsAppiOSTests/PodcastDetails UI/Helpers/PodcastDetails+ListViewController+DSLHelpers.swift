// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import PodcastsModuleiOS

extension ListViewController {
    private var episodesSection: Int {
        return 0
    }
    
    func numberOfRenderedEpisodesViews() -> Int {
        return tableView.numberOfRows(inSection: episodesSection)
    }
    
    func episodeView(at row: Int) -> EpisodeCell? {
        return view(at: row, section: episodesSection) as? EpisodeCell
    }
}

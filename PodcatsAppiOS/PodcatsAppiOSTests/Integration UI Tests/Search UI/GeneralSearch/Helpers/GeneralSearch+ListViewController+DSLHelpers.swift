// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import SharedComponentsiOSModule

extension ListViewController {
        
    private var searchTermsSection: Int {
        return 0
    }
        
    func numberOfRenderedSearchedEpisodesViews() -> Int {
        return tableView.numberOfRows(inSection: searchTermsSection)
    }
}

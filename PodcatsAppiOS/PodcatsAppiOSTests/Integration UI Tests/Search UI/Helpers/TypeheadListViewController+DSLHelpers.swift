// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import SearchContentModuleiOS

extension TypeheadListViewController {
    
    private var searchTermsSection: Int {
        return 0
    }
    
    func searchTermView(at row: Int) -> UITableViewCell? {
        return view(at: row, section: searchTermsSection)
    }
    
    func numberOfRenderedSearchTermViews() -> Int {
        return tableView.numberOfRows(inSection: searchTermsSection)
    }
    
    func simulateUserInitiatedTermSelection(at row: Int) {
        tableView.delegate?.tableView?(tableView, didSelectRowAt: IndexPath(row: row, section: searchTermsSection))
    }
}

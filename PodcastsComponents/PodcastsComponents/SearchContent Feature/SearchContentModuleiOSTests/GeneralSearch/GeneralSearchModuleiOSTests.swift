// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import SharedTestHelpersLibrary
import SharedComponentsiOSModule
import SearchContentModule
import SearchContentModuleiOS

final class GeneralSearchModuleiOSTests: XCTestCase {
    
    func test_emptyPodcastDetails() {
        let sut = makeSUT()
        
        sut.display(emptySearchResult())
        
        assert(snapshot: sut.snapshot(for: .iPhone14(style: .light)), named: "EMPTY_PODCAST_DETAILS_light")
        assert(snapshot: sut.snapshot(for: .iPhone14(style: .dark)), named: "EMPTY_PODCAST_DETAILS_dark")
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> ListViewController {
        let controller = ListViewController(refreshController: nil)
        controller.loadViewIfNeeded()
        controller.tableView.showsVerticalScrollIndicator = false
        controller.tableView.showsHorizontalScrollIndicator = false
        return controller
    }
    
    private func emptySearchResult() -> [SectionController] {
        return [DefaultSectionWithNoHeaderAndFooter(cellControllers: [])]
    }
}

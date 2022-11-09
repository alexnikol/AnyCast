// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import LoadResourcePresenter
import PodcastsModule
import PodcastsModuleiOS

class PodcastDetailsUISnapshotTests: XCTestCase {
    
    func test_emptyPodcastDetails() {
        let (sut, _) = makeSUT()
        
        sut.display(emptyPodcastDetails())
        
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "EMPTY_PODCAST_DETAILS_light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "EMPTY_PODCAST_DETAILS_dark")
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: ListViewController, loadingView: ResourceLoadingView) {
        let refreshController = RefreshViewController(delegate: NullObjectRefreshViewControllerDelegate())
        let controller = ListViewController(refreshController: refreshController)
        controller.loadViewIfNeeded()
        controller.tableView.showsVerticalScrollIndicator = false
        controller.tableView.showsHorizontalScrollIndicator = false
        return (controller, refreshController)
    }
    
    private class NullObjectRefreshViewControllerDelegate: RefreshViewControllerDelegate {
        func didRequestLoading() {}
    }
    
    private func emptyPodcastDetails() -> [EpisodeCellController] {
        return []
    }
}

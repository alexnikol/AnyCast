// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import LoadResourcePresenter
import BestPodcastsListiOS

class BestPodcastsUIIntegrationTests: XCTestCase {
    
    func test_emptyBestPodcasts() {
        let (sut, _) = makeSUT()
        
        sut.display(emptyPodcasts())
        
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "EMPTY_BEST_PODCASTS_light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "EMPTY_BEST_PODCASTS_dark")
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: BestPodcastsListViewController, loadingView: ResourceLoadingView) {
        let refreshController = BestPodcastsListRefreshViewController(delegate: NullObjectRefreshViewControllerDelegate())
        let controller = BestPodcastsListViewController(refreshController: refreshController)
        controller.loadViewIfNeeded()
        return (controller, refreshController)
    }
    
    private class NullObjectRefreshViewControllerDelegate: BestPodcastsListRefreshViewControllerDelegate {
        func didRequestLoadingPodcasts() {}
    }
    
    private func emptyPodcasts() -> [PodcastCellController] {
        return []
    }
}

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
    
    func test_bestPodcastsWithContent() {
        let (sut, _) = makeSUT()
        
        sut.display(podcastsList())
        
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "BEST_PODCASTS_WITH_CONTENT_light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "BEST_PODCASTS_WITH_CONTENT_dark")
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: BestPodcastsListViewController, loadingView: ResourceLoadingView) {
        let refreshController = BestPodcastsListRefreshViewController(delegate: NullObjectRefreshViewControllerDelegate())
        let controller = BestPodcastsListViewController(refreshController: refreshController)
        controller.loadViewIfNeeded()
        controller.tableView.showsVerticalScrollIndicator = false
        controller.tableView.showsHorizontalScrollIndicator = false
        return (controller, refreshController)
    }
        
    private func emptyPodcasts() -> [PodcastCellController] {
        return []
    }
    
    private func podcastsList() -> [PodcastCellController] {
        return [
            PodcastCellController(model: .init(title: "Title with no image", image: nil), delegete: CellDelegate()),
            PodcastCellController(model: .init(title: "Title 1", image: UIImage.make(withColor: .red)), delegete: CellDelegate()),
            PodcastCellController(model: .init(title: String(repeating: "Long ", count: 10) + "title", image: UIImage.make(withColor: .green)), delegete: CellDelegate()),
            PodcastCellController(model: .init(title: "Another title", image: nil), delegete: CellDelegate())
        ]
    }
    
    private class NullObjectRefreshViewControllerDelegate: BestPodcastsListRefreshViewControllerDelegate {
        func didRequestLoadingPodcasts() {}
    }
    
    private class CellDelegate: PodcastCellControllerDelegate {
        func didRequestImage() {}
        
        func didCancelImageLoad() {}
    }
}

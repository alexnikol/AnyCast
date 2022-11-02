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
        
        sut.display(podcastsList() + podcastsList())
        
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
            PodcastCellController(
                model: .init(
                    title: "Any name",
                    publisher: "Any publisher",
                    languageStaticLabel: "Language:",
                    languageValueLabel: "Any language",
                    typeStaticLabel: "Type:",
                    typeValueLabel: "Any type",
                    image: anyURL()),
                delegete: CellDelegate()
            ),
            PodcastCellController(
                model: .init(
                    title: "Another name",
                    publisher: "Another publisher",
                    languageStaticLabel: "Language:",
                    languageValueLabel: "Another language",
                    typeStaticLabel: "Type:",
                    typeValueLabel: "Another type",
                    image: anyURL()),
                delegete: CellDelegate()
            ),
            PodcastCellController(
                model: .init(
                    title: "Long long long long long long long long long long long long long long long long name",
                    publisher: "Long long long long long publisher",
                    languageStaticLabel: "Language:",
                    languageValueLabel: "Long long long long long language",
                    typeStaticLabel: "Type:",
                    typeValueLabel: "Long long long long long type",
                    image: anyURL()),
                delegete: CellDelegate()
            )
        ]
    }
    
    private func anyURL() -> URL {
        URL(string: "http://a-url.com")!
    }
    
    private class NullObjectRefreshViewControllerDelegate: BestPodcastsListRefreshViewControllerDelegate {
        func didRequestLoadingPodcasts() {}
    }
    
    private class CellDelegate: PodcastCellControllerDelegate {
        func didRequestImage() {}
        
        func didCancelImageLoad() {}
    }
}

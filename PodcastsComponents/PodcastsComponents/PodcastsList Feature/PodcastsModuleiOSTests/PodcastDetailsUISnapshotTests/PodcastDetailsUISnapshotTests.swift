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
    
    func test_podcastDetailsWithContent() {
        let (sut, _) = makeSUT()
        
        sut.display(podcastDetailsWithContent())
        
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "PODCAST_DETAILS_WITH_CONTENT_light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "PODCAST_DETAILS_WITH_CONTENT_dark")
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
    
    private func podcastDetailsWithContent() -> [EpisodeCellController] {
        return [
            EpisodeCellController(
                viewModel: EpisodeViewModel(
                    title: "Any Episode title",
                    description: "",
                    thumbnail: anyURL(),
                    audio: anyURL(),
                    displayAudioLengthInSeconds: "44 hours 22 min",
                    displayPublishDate: "5 years ago"
                )
            ),
//            EpisodeCellController(
//                viewModel: EpisodeViewModel(
//                    title: "Any Episode title".repeatTimes(10),
//                    description: "Any Description",
//                    thumbnail: anyURL(),
//                    audio: anyURL(),
//                    displayAudioLengthInSeconds: "44 hours 22 min".repeatTimes(10),
//                    displayPublishDate: "5 days ago"
//                )
//            ),
//            EpisodeCellController(
//                viewModel: EpisodeViewModel(
//                    title: "Any Episode title".repeatTimes(10),
//                    description: "Any Description".repeatTimes(10),
//                    thumbnail: anyURL(),
//                    audio: anyURL(),
//                    displayAudioLengthInSeconds: "1 min".repeatTimes(10),
//                    displayPublishDate: "5 min ago".repeatTimes(20)
//                )
//            )
        ]
    }
}

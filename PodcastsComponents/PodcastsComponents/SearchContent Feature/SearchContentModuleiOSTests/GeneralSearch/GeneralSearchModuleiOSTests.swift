// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import LoadResourcePresenter
import SharedTestHelpersLibrary
import SharedComponentsiOSModule
import SearchContentModule
import SearchContentModuleiOS
import PodcastsModule
import PodcastsModuleiOS

final class GeneralSearchModuleiOSTests: XCTestCase {
    
    func test_emptySearchDetails() {
        let sut = makeSUT()
        
        sut.display(emptySearchResult())
        
        assert(snapshot: sut.snapshot(for: .iPhone14(style: .light)), named: "EMPTY_GENERAL_SEARCH_light")
        assert(snapshot: sut.snapshot(for: .iPhone14(style: .dark)), named: "EMPTY_GENERAL_SEARCH_dark")
    }
    
    func test_episodesSearchDetails() {
        let sut = makeSUT()
        
        sut.display(episodesSearchResult() + podcastsSearchResult())
        
        record(snapshot: sut.snapshot(for: .iPhone14(style: .light)), named: "LIST_GENERAL_SEARCH_light")
        record(snapshot: sut.snapshot(for: .iPhone14(style: .dark)), named: "LIST_GENERAL_SEARCH_dark")
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
        
    private func episodesSearchResult() -> [SectionController] {
        let cellControllers = [
            EpisodeCellController(
                viewModel: EpisodeViewModel(
                    title: "Any Episode title",
                    description: "Any Description",
                    thumbnail: anyURL(),
                    audio: anyURL(),
                    displayAudioLengthInSeconds: "44 hours 22 min",
                    displayPublishDate: "5 years ago"
                ),
                selection: {}
            ),
            EpisodeCellController(
                viewModel: EpisodeViewModel(
                    title: "Any Episode title".repeatTimes(10),
                    description: "Any Description",
                    thumbnail: anyURL(),
                    audio: anyURL(),
                    displayAudioLengthInSeconds: "44 hours 22 min".repeatTimes(10),
                    displayPublishDate: "5 days ago"
                ),
                selection: {}
            )
        ]
        return [DefaultSectionWithNoHeaderAndFooter(cellControllers: cellControllers)]
    }
    
    private func podcastsSearchResult() -> [SectionController] {
        let viewModels: [SearchResultPodcastViewModel] = [
            SearchResultPodcastViewModel(
                title: "Podcast",
                publisher: "Publisher",
                thumbnail: anyURL()
            ),
            SearchResultPodcastViewModel(
                title: "Podcast " + "long ".repeatTimes(20),
                publisher: "Publisher " + "long ".repeatTimes(20),
                thumbnail: anotherURL()
            ),
            SearchResultPodcastViewModel(
                title: "Podcast short",
                publisher: "Publisher " + "long ".repeatTimes(20),
                thumbnail: anotherURL()
            )
        ]
        let colors: [UIColor] = [.red, .yellow, .green]
        let cellControllers = viewModels.enumerated().map { (index, model) -> SearchResultPodcastCellController in
            let refreshDelegate = ImageStub(image: UIImage.make(withColor: colors[index]))
            let thumbnailViewController = ThumbnailViewController(loaderDelegate: refreshDelegate)
            refreshDelegate.thumbnailViewController = thumbnailViewController
            
            return SearchResultPodcastCellController(
                model: model,
                thumbnailViewController: thumbnailViewController,
                selection: {}
            )
        }
        return [DefaultSectionWithNoHeaderAndFooter(cellControllers: cellControllers)]
    }
        
    private class ImageStub: RefreshViewControllerDelegate {
        private let image: UIImage?
        
        init(image: UIImage?) {
            self.image = image
        }
        
        weak var thumbnailViewController: ThumbnailViewController?
        
        func didRequestLoading() {
            if let image = image {
                thumbnailViewController?.display(image)
            } else {
                thumbnailViewController?.display(ResourceErrorViewModel(message: "ERROR_MESSAGE"))
            }
        }
        
        func didRequestCancel() {}
    }
}

// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import Combine
import SharedTestHelpersLibrary
import SharedComponentsiOSModule
import SearchContentModule
import SearchContentModuleiOS
import PodcastsModule
@testable import Podcats

final class GeneralSearchUIIntegrationTests: XCTestCase {
    
    func test_loadGeneralSearchResultActions_requestGeneralSearchOnTermChange() {
        let (sut, sourceDelegate, loader) = makeSUT()
        
        XCTAssertEqual(loader.loadCallCount, 0, "Expected no loading requests before view is loaded")
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.loadCallCount, 0, "Expected a no loading request once view is loaded")
        
        sourceDelegate.didUpdateSearchTerm("any search term")
        XCTAssertEqual(loader.loadCallCount, 1, "Expected loading request on text change")
        
        sourceDelegate.didUpdateSearchTerm("another search term")
        XCTAssertEqual(loader.loadCallCount, 2, "Expected 2 loading requests on text change")
    }
    
    func test_loadGeneralSearchResultCompletion_rendersSuccessfullyLoadedTerms() {
        let (sut, sourceDelegate, loader) = makeSUT()
        sut.loadViewIfNeeded()
        assertThat(sut, isRenderingEpisodes: [])
        
        sourceDelegate.simulateSearchTermReceiving(term: "term 1")
        assertThat(sut, isRenderingEpisodes: [])
    
        let episode1 = makeEpisode()
        let episode2 = makeEpisode()
        loader.completeRequest(with: .init(result: [.episode(episode1), .episode(episode2)]), atIndex: 0)
        assertThat(sut, isRenderingEpisodes: [episode1, episode2])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: ListViewController, sourceDelegate: GeneralSearchSourceDelegate, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let searchResultController = SearchResultViewControllerNullObject()
        let (sut, sourceDelegate) = GeneralSearchUIComposer
            .searchComposedWith(
                searchResultController: searchResultController,
                searchLoader: loader.loadPublisher
            )
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        return (sut, sourceDelegate, loader)
    }
    
    private func assertThat(
        _ sut: ListViewController,
        isRenderingEpisodes episodes: [Episode],
        file: StaticString = #file,
        line: UInt = #line
    ) {
        guard sut.numberOfRenderedSearchedEpisodesViews() == episodes.count else {
            return XCTFail("Expected \(episodes.count) rendered episodes, got \(sut.numberOfRenderedSearchedEpisodesViews()) rendered views instead", file: file, line: line)
        }
        
        episodes.enumerated().forEach { index, episode in
            assertThat(sut, hasViewConfiguredFor: episode, at: index, file: file, line: line)
        }
    }
    
    private func assertThat(
        _ sut: ListViewController,
        hasViewConfiguredFor episode: Episode,
        at index: Int,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let calendar = Calendar(identifier: .gregorian)
        let locale = Locale(identifier: "en_US_POSIX")
        let episodeViewModel = GeneralSearchContentPresenter.map(episode, calendar: calendar, locale: locale)
        let view = sut.searchEpisodeView(at: index)
        XCTAssertNotNil(view, file: file, line: line)
        XCTAssertEqual(view?.titleText, episodeViewModel.title, "Wrong title at index \(index)", file: file, line: line)
        XCTAssertEqual(view?.descriptionText, episodeViewModel.description, "Wrong description at index \(index)", file: file, line: line)
        XCTAssertEqual(view?.audioLengthText, episodeViewModel.displayAudioLengthInSeconds, "Wrong audio length at index \(index)", file: file, line: line)
        XCTAssertEqual(view?.publishDateText, episodeViewModel.displayPublishDate, "Wrong publish date at index \(index)", file: file, line: line)
    }
    
    private class LoaderSpy {
        typealias Publsiher = AnyPublisher<GeneralSearchContentResult, Error>
        
        private var requests = [PassthroughSubject<GeneralSearchContentResult, Error>]()
        private(set) var cancelledTerms = [String]()
        
        var loadCallCount: Int {
            return requests.count
        }
        
        func loadPublisher(for searchTerm: String) -> Publsiher {
            let publisher = PassthroughSubject<GeneralSearchContentResult, Error>()
            
            let cancelPublisher = publisher.handleEvents(receiveCancel: { [weak self] in
                self?.cancelledTerms.append(searchTerm)
            })
            requests.append(publisher)
            return cancelPublisher.eraseToAnyPublisher()
        }
        
        func completeRequest(with result: GeneralSearchContentResult, atIndex index: Int) {
            requests[index].send(result)
        }
        
        func completeRequestWitError(atIndex index: Int) {
            requests[index].send(completion: .failure(anyNSError()))
        }
    }
    
    private final class SearchResultViewControllerNullObject: UIViewController, UISearchBarDelegate {
        
    }
}

private extension GeneralSearchSourceDelegate {
    func simulateSearchTermReceiving(term: String) {
        self.didUpdateSearchTerm(term)
    }
}

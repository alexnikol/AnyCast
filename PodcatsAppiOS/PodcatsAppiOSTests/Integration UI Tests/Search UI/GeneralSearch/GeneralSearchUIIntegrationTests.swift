// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import Combine
import SharedTestHelpersLibrary
import SharedComponentsiOSModule
import SearchContentModule
import SearchContentModuleiOS
import PodcastsModule
@testable import Podcats

final class GeneralSearchUIIntegrationTests: XCTestCase, LocalizationUITestCase {
    
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
        
        assertThat(sut, isRenderingSearchResult: .init(episodes: [], podcasts: [], curatedLists: []))
        
        sourceDelegate.simulateSearchTermReceiving(term: "term 1")
        assertThat(sut, isRenderingSearchResult: .init(episodes: [], podcasts: [], curatedLists: []))
        
        let (models, result) = makeGeneralSearchContentResult()
        loader.completeRequest(with: result, atIndex: 0)
        
        assertThat(sut, isRenderingSearchResult: models)
    }
    
    func test_loadGeneralSearchResultCompletion_doesNotAlterCurrentRenderingStateOnError() {
        let (sut, sourceDelegate, loader) = makeSUT()
        sut.loadViewIfNeeded()
        
        sourceDelegate.simulateSearchTermReceiving(term: "term 1")
        let (models, result) = makeGeneralSearchContentResult()
        loader.completeRequest(with: result, atIndex: 0)
        assertThat(sut, isRenderingSearchResult: models)
        
        sourceDelegate.simulateSearchTermReceiving(term: "term 2")
        loader.completeRequestWitError(atIndex: 1)
        assertThat(sut, isRenderingSearchResult: models)
    }
    
    func test_loadGeneralSearchResultCancel_cancelsPreviousRequestBeforeNewRequest() {
        let (sut, sourceDelegate, loader) = makeSUT()
        sut.loadViewIfNeeded()
        
        let searchTerm0 = "any search term"
        sourceDelegate.simulateSearchTermReceiving(term: searchTerm0)
        XCTAssertEqual(loader.cancelledTerms, [])
        
        let searchTerm1 = "any search term 2"
        sourceDelegate.simulateSearchTermReceiving(term: searchTerm1)
        XCTAssertEqual(loader.cancelledTerms, [searchTerm0])
        
        let searchTerm2 = "any search term 3"
        sourceDelegate.simulateSearchTermReceiving(term: searchTerm2)
        XCTAssertEqual(loader.cancelledTerms, [searchTerm0, searchTerm1])
    }
    
    func test_onTermSelection_deliversSelectedTerm() {
        var receivedEpisodes: [SearchResultEpisode] = []
        var receivedPodcasts: [SearchResultPodcast] = []
        let expEpisode = expectation(description: "Wait on episode selection")
        let expPodcast = expectation(description: "Wait on podcast selection")
        expPodcast.assertForOverFulfill = false
        
        let (sut, searchController, loader) = makeSUT(
            onEpisodeSelect: { episode in
                receivedEpisodes.append(episode)
                expEpisode.fulfill()
            }, onPodcastSelect: { podcast in
                receivedPodcasts.append(podcast)
                expPodcast.fulfill()
            }
        )
        sut.loadViewIfNeeded()
        
        searchController.simulateSearchTermReceiving(term: "any search term")
        let (models, result) = makeGeneralSearchContentResult()
        loader.completeRequest(with: result, atIndex: 0)
        
        sut.simulateUserInitiatedSearchedEpisodeSelection(at: 0)
        sut.simulateUserInitiatedSearchedPodcastSelection(at: 1)
        sut.simulateUserInitiatedSearchedPodcastFromCuratedListSelection(at: 1)
        
        wait(for: [expEpisode, expPodcast], timeout: 1.0)
        
        XCTAssertEqual(receivedEpisodes, [models.episodes[0]])
        XCTAssertEqual(receivedPodcasts, [models.podcasts[1]] + [models.curatedLists[0].podcasts[1]])
    }
    
    func test_loadGeneralSearchResultCompletion_dispatchesFromBackgroundToMainThread() {
        let (sut, searchController, loader) = makeSUT()
        sut.loadViewIfNeeded()
        searchController.simulateSearchTermReceiving(term: "any search term")
        let (_, result) = makeGeneralSearchContentResult()
        
        let exp = expectation(description: "Wait for background queue")
        DispatchQueue.global().async {
            loader.completeRequest(with: result, atIndex: 0)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        onEpisodeSelect: @escaping (SearchResultEpisode) -> Void = { _ in },
        onPodcastSelect: @escaping (SearchResultPodcast) -> Void = { _ in },
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: ListViewController, sourceDelegate: GeneralSearchSourceDelegate, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let searchResultController = SearchResultViewControllerNullObject()
        let (sut, sourceDelegate) = GeneralSearchUIComposer
            .searchComposedWith(
                searchResultController: searchResultController,
                searchLoader: loader.loadPublisher,
                onEpisodeSelect: onEpisodeSelect,
                onPodcastSelect: onPodcastSelect
            )
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        return (sut, sourceDelegate, loader)
    }
    
    private func makeGeneralSearchPresenter(file: StaticString = #file, line: UInt = #line) -> GeneralSearchContentPresenter {
        let calendar = Calendar(identifier: .gregorian)
        let locale = Locale(identifier: "en_US_POSIX")
        let episodesPresenter = GeneralSearchContentPresenter(calendar: calendar, locale: locale)
        trackForMemoryLeaks(episodesPresenter)
        return episodesPresenter
    }
    
    private func assertThat(
        _ sut: ListViewController,
        isRenderingEpisodes episodes: [SearchResultEpisode],
        file: StaticString = #file,
        line: UInt = #line
    ) {
        guard sut.numberOfRenderedSearchedEpisodesViews() == episodes.count else {
            return XCTFail("Expected \(episodes.count) rendered episodes, got \(sut.numberOfRenderedSearchedEpisodesViews()) rendered views instead", file: file, line: line)
        }
        
        let (title, description) = sut.episodesSectionTitle()
        if !episodes.isEmpty {
            XCTAssertEqual(title, localized("GENERAL_SEARCH_SECTION_EPISODES", bundle: bundle, table: tableName))
            XCTAssertEqual(description, nil)
        } else {
            XCTAssertEqual(title, nil)
            XCTAssertEqual(description, nil)
        }
        
        episodes.enumerated().forEach { index, episode in
            assertThat(sut, hasViewConfiguredFor: episode, at: index, file: file, line: line)
        }
    }
    
    private func assertThat(
        _ sut: ListViewController,
        isRenderingPodcasts podcasts: [SearchResultPodcast],
        file: StaticString = #file,
        line: UInt = #line
    ) {
        guard sut.numberOfRenderedSearchedPodcastsViews() == podcasts.count else {
            return XCTFail("Expected \(podcasts.count) rendered podcasts, got \(sut.numberOfRenderedSearchedPodcastsViews()) rendered views instead", file: file, line: line)
        }
        
        let (title, description) = sut.podcastsSectionTitle()
        if !podcasts.isEmpty {
            XCTAssertEqual(title, localized("GENERAL_SEARCH_SECTION_PODCASTS", bundle: bundle, table: tableName))
            XCTAssertEqual(description, nil)
        } else {
            XCTAssertEqual(title, nil)
            XCTAssertEqual(description, nil)
        }
        
        podcasts.enumerated().forEach { index, podcast in
            assertThat(sut, hasViewConfiguredFor: podcast, at: index, file: file, line: line)
        }
    }
    
    private func assertThat(
        _ sut: ListViewController,
        isRenderingSearchResult searchResult: GeneralSearchResult,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        assertThat(sut, isRenderingEpisodes: searchResult.episodes, file: file, line: line)
        assertThat(sut, isRenderingPodcasts: searchResult.podcasts, file: file, line: line)
        assertThat(sut, isRenderingCuratedLists: searchResult.curatedLists, file: file, line: line)
    }
    
    private func assertThat(
        _ sut: ListViewController,
        isRenderingCuratedLists curatedLists: [SearchResultCuratedList],
        file: StaticString = #file,
        line: UInt = #line
    ) {
        guard sut.numberOfCuratedList() == curatedLists.count else {
            return XCTFail("Expected \(curatedLists.count) rendered curated lists, got \(sut.numberOfCuratedList()) rendered views instead", file: file, line: line)
        }
        
        guard !curatedLists.isEmpty else { return }
        
        let curatedList0Titles = sut.sectionTitleAndDescription(section: 2)
        XCTAssertEqual(curatedList0Titles.title, curatedLists[0].titleOriginal)
        XCTAssertEqual(curatedList0Titles.decription, curatedLists[0].descriptionOriginal)
        
        curatedLists[0].podcasts.enumerated().forEach { index, podcast in
            assertThat(
                sut,
                hasViewConfiguredForPodcastInCuratedList: podcast,
                at: IndexPath(row: index, section: 2),
                file: file,
                line: line
            )
        }
        
        let curatedList1Titles = sut.sectionTitleAndDescription(section: 3)
        XCTAssertEqual(curatedList1Titles.title, curatedLists[1].titleOriginal)
        XCTAssertEqual(curatedList1Titles.decription, curatedLists[1].descriptionOriginal)
        
        curatedLists[1].podcasts.enumerated().forEach { index, podcast in
            assertThat(
                sut,
                hasViewConfiguredForPodcastInCuratedList: podcast,
                at: IndexPath(row: index, section: 3),
                file: file,
                line: line
            )
        }
    }
    
    private func assertThat(
        _ sut: ListViewController,
        hasViewConfiguredFor episode: SearchResultEpisode,
        at index: Int,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let episodeViewModel = makeGeneralSearchPresenter().map(episode)
        let view = sut.searchEpisodeView(at: index)
        XCTAssertNotNil(view, file: file, line: line)
        XCTAssertEqual(view?.titleText, episodeViewModel.title, "Wrong title at index \(index)", file: file, line: line)
        XCTAssertEqual(view?.descriptionText, episodeViewModel.description, "Wrong description at index \(index)", file: file, line: line)
        XCTAssertEqual(view?.audioLengthText, episodeViewModel.displayAudioLengthInSeconds, "Wrong audio length at index \(index)", file: file, line: line)
        XCTAssertEqual(view?.publishDateText, episodeViewModel.displayPublishDate, "Wrong publish date at index \(index)", file: file, line: line)
    }
    
    private func assertThat(
        _ sut: ListViewController,
        hasViewConfiguredFor podcast: SearchResultPodcast,
        at index: Int,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let podcastViewModel = makeGeneralSearchPresenter().map(podcast)
        let view = sut.searchPodcastView(at: index)
        XCTAssertNotNil(view, file: file, line: line)
        XCTAssertEqual(view?.titleText, podcastViewModel.title, "Wrong title at index \(index)", file: file, line: line)
        XCTAssertEqual(view?.publisherText, podcastViewModel.publisher, "Wrong publisher at index \(index)", file: file, line: line)
    }
    
    private func assertThat(
        _ sut: ListViewController,
        hasViewConfiguredForPodcastInCuratedList podcast: SearchResultPodcast,
        at indexPath: IndexPath,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let podcastViewModel = makeGeneralSearchPresenter().map(podcast)
        let view = sut.searchPodcastCuratedListView(at: indexPath.row, curatedListSection: indexPath.section)
        XCTAssertNotNil(view, file: file, line: line)
        XCTAssertEqual(view?.titleText, podcastViewModel.title, "Wrong title at indexPath \(indexPath)", file: file, line: line)
        XCTAssertEqual(view?.publisherText, podcastViewModel.publisher, "Wrong publisher at indexPath \(indexPath)", file: file, line: line)
    }
    
    private var tableName: String {
        "GeneralSearch"
    }
    
    private var bundle: Bundle {
        Bundle(for: GeneralSearchContentPresenter.self)
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
    
    private final class SearchResultViewControllerNullObject: UIViewController, UISearchBarDelegate {}
}

private extension GeneralSearchSourceDelegate {
    func simulateSearchTermReceiving(term: String) {
        self.didUpdateSearchTerm(term)
    }
}

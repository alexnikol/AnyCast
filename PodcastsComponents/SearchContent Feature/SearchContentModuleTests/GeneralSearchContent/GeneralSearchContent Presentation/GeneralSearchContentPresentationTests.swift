// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import SharedTestHelpersLibrary
import SearchContentModule

final class GeneralSearchContentPresentationTests: XCTestCase {
    
    func test_createsViewModel() {
        let domainModel = uniqueGeneralSearchContentResult()
        let viewModel = makeSUT().map(domainModel)
        
        XCTAssertEqual(viewModel.episodes.count, 2)
        assert(receivedEpisode: viewModel.episodes[0], domainItem: domainModel.result[0])
        assert(receivedEpisode: viewModel.episodes[1], domainItem: domainModel.result[1])
        
        XCTAssertEqual(viewModel.podcasts.count, 2)
        assert(receivedPodcast: viewModel.podcasts[0], domainItem: domainModel.result[2])
        assert(receivedPodcast: viewModel.podcasts[1], domainItem: domainModel.result[3])
        
        XCTAssertEqual(viewModel.curatedLists.count, 2)
        assert(receivedCuratedList: viewModel.curatedLists[0], domainItem: domainModel.result[4])
        assert(receivedCuratedList: viewModel.curatedLists[1], domainItem: domainModel.result[5])
    }
    
    func test_createsSearchResultEpisodeViewModel() {
        let episode = uniqueEpisodeSearchResults()[0]
        
        let episodeViewModel = makeSUT().map(episode)
        XCTAssertEqual(episodeViewModel.title, episode.title)
        XCTAssertEqual(episodeViewModel.description, episode.description)
        XCTAssertEqual(episodeViewModel.thumbnail, episode.thumbnail)
    }
    
    func test_createsSearchResultPodcastViewModel() {
        let podcast = uniquePodcastSearchResults()[0]
        
        let podcastViewModel = makeSUT().map(podcast)
        XCTAssertEqual(podcastViewModel.title, podcast.titleOriginal)
        XCTAssertEqual(podcastViewModel.publisher, podcast.publisherOriginal)
        XCTAssertEqual(podcastViewModel.thumbnail, podcast.thumbnail)
    }
    
    func test_createsSearchResultCuratedListViewModel() {
        let curatedList = uniqueCuratedListsSearchResults()[0]
        
        let curatedListViewModel = makeSUT().map(curatedList)
        XCTAssertEqual(curatedListViewModel.title, curatedList.titleOriginal)
        XCTAssertEqual(curatedListViewModel.description, curatedList.descriptionOriginal)
        XCTAssertEqual(curatedListViewModel.podcasts, curatedList.podcasts)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> GeneralSearchContentPresenter {
        let calendar = Calendar(identifier: .gregorian)
        let locale = Locale(identifier: "en_US_POSIX")
        let episodesPresenter = GeneralSearchContentPresenter(calendar: calendar, locale: locale)
        trackForMemoryLeaks(episodesPresenter)
        return episodesPresenter
    }
    
    private func assert(
        receivedPodcast: SearchResultPodcast,
        domainItem: GeneralSearchContentResultItem,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        guard case let .podcast(podcast) = domainItem else {
            XCTFail("domainItem should be podcast, but it is \(domainItem)", file: file, line: line)
            return
        }
        XCTAssertEqual(podcast, receivedPodcast, file: file, line: line)
    }
    
    private func assert(
        receivedEpisode: SearchResultEpisode,
        domainItem: GeneralSearchContentResultItem,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        guard case let .episode(episode) = domainItem else {
            XCTFail("domainItem should be episode, but it is \(domainItem)", file: file, line: line)
            return
        }
        XCTAssertEqual(episode, receivedEpisode, file: file, line: line)
    }
    
    private func assert(
        receivedCuratedList: SearchResultCuratedList,
        domainItem: GeneralSearchContentResultItem,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        guard case let .curatedList(curatedList) = domainItem else {
            XCTFail("domainItem should be curated list, but it is \(domainItem)", file: file, line: line)
            return
        }
        XCTAssertEqual(curatedList, receivedCuratedList, file: file, line: line)
    }
    
    private func uniqueGeneralSearchContentResult() -> GeneralSearchContentResult {
        let episodes = uniqueEpisodeSearchResults().map(GeneralSearchContentResultItem.episode)
        let podcasts = uniquePodcastSearchResults().map(GeneralSearchContentResultItem.podcast)
        let curatedLists = uniqueCuratedListsSearchResults().map(GeneralSearchContentResultItem.curatedList)
        
        let domainItems = episodes + podcasts + curatedLists
        return GeneralSearchContentResult(result: domainItems)
    }
}

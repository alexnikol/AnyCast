// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import SharedTestHelpersLibrary
import SearchContentModule

final class GeneralSearchContentPresentationTests: XCTestCase {
    
    func test_createsViewModel() {
        let domainModel = uniqueGeneralSearchContentResult()
        let viewModel = GeneralSearchContentPresenter.map(domainModel)
        
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
        let episode = uniqueGeneralSearchEpisodes()[0]
        
        let episodeViewModel = GeneralSearchContentPresenter.map(episode)
        XCTAssertEqual(episodeViewModel.title, episode.titleOriginal)
        XCTAssertEqual(episodeViewModel.description, episode.descriptionOriginal)
        XCTAssertEqual(episodeViewModel.thumbnail, episode.thumbnail)
    }
    
    func test_createsSearchResultPodcastViewModel() {
        let podcast = uniqueGeneralSearchPodcasts()[0]
        
        let podcastViewModel = GeneralSearchContentPresenter.map(podcast)
        XCTAssertEqual(podcastViewModel.title, podcast.titleOriginal)
        XCTAssertEqual(podcastViewModel.publisher, podcast.publisherOriginal)
        XCTAssertEqual(podcastViewModel.thumbnail, podcast.thumbnail)
    }
    
    func test_createsSearchResultCuratedListViewModel() {
        let curatedList = uniqueGeneralSearchCuratedLists()[0]
        
        let curatedListViewModel = GeneralSearchContentPresenter.map(curatedList)
        XCTAssertEqual(curatedListViewModel.title, curatedList.titleOriginal)
        XCTAssertEqual(curatedListViewModel.description, curatedList.descriptionOriginal)
        XCTAssertEqual(curatedListViewModel.podcasts, curatedList.podcasts)
    }
    
    // MARK: - Helpers
    
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
        let episodes = uniqueGeneralSearchEpisodes().map(GeneralSearchContentResultItem.episode)
        let podcasts = uniqueGeneralSearchPodcasts().map(GeneralSearchContentResultItem.podcast)
        let curatedLists = uniqueGeneralSearchCuratedLists().map(GeneralSearchContentResultItem.curatedList)
        
        let domainItems = episodes + podcasts + curatedLists
        return GeneralSearchContentResult(result: domainItems)
    }
    
    private func uniqueGeneralSearchEpisodes() -> [SearchResultEpisode] {
        [
            SearchResultEpisode(
                id: UUID().uuidString,
                titleOriginal: "Episode title",
                descriptionOriginal: "Description",
                image: anyURL(),
                thumbnail: anotherURL()
            ),
            SearchResultEpisode(
                id: UUID().uuidString,
                titleOriginal: "Another Episode Title",
                descriptionOriginal: "Another Description",
                image: anyURL(),
                thumbnail: anotherURL()
            )
        ]
    }
    
    private func uniqueGeneralSearchPodcasts() -> [SearchResultPodcast] {
        [
            SearchResultPodcast(
                id: UUID().uuidString,
                titleOriginal: "Podcast Title",
                publisherOriginal: "Publisher",
                image: anyURL(),
                thumbnail: anotherURL()
            ),
            SearchResultPodcast(
                id: UUID().uuidString,
                titleOriginal: "Another Podcast Title",
                publisherOriginal: "Another Publisher",
                image: anyURL(),
                thumbnail: anotherURL()
            )
        ]
    }
    
    private func uniqueGeneralSearchCuratedLists() -> [SearchResultCuratedList] {
        [
            SearchResultCuratedList(
                id: UUID().uuidString,
                titleOriginal: "Curated Title",
                descriptionOriginal: "Curated Description",
                podcasts: [
                    SearchResultPodcast(
                        id: UUID().uuidString,
                        titleOriginal: "Curated Podcast Title",
                        publisherOriginal: "Curated Publisher",
                        image: anyURL(),
                        thumbnail: anotherURL()
                    ),
                    SearchResultPodcast(
                        id: UUID().uuidString,
                        titleOriginal: "Another Curated Podcast title",
                        publisherOriginal: "Another Curated Publisher",
                        image: anyURL(),
                        thumbnail: anotherURL()
                    )
                ]
            ),
            SearchResultCuratedList(
                id: UUID().uuidString,
                titleOriginal: "Another Curated Title",
                descriptionOriginal: "Another Curated Description",
                podcasts: [
                    SearchResultPodcast(
                        id: UUID().uuidString,
                        titleOriginal: "One More Curated Podcast Title",
                        publisherOriginal: "One More Curated Publisher",
                        image: anyURL(),
                        thumbnail: anotherURL()
                    )
                ]
            )
        ]
    }
}

// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import SharedTestHelpersLibrary
import SearchContentModule

struct GeneralSearchContentResultViewModel {
    let episodes: [SearchResultEpisode]
    let podcasts: [SearchResultPodcast]
    let curatedLists: [SearchResultCuratedList]
}

struct SearchResultEpisodeViewModel {
    let title: String
    let description: String
    let thumbnail: URL
    
    init(title: String, description: String, thumbnail: URL) {
        self.title = title
        self.description = description
        self.thumbnail = thumbnail
    }
}

struct SearchResultPodcastViewModel {
    let title: String
    let publisher: String
    let thumbnail: URL
    
    init(title: String, publisher: String, thumbnail: URL) {
        self.title = title
        self.publisher = publisher
        self.thumbnail = thumbnail
    }
}

struct SearchResultCuratedListViewModel {
    let title: String
    let description: String
    let podcasts: [SearchResultPodcast]
    
    init(title: String, description: String, podcasts: [SearchResultPodcast]) {
        self.title = title
        self.description = description
        self.podcasts = podcasts
    }
}

final class GeneralSearchContentPresenter {
    private init() {}
    
    static func map(_ model: GeneralSearchContentResult) -> GeneralSearchContentResultViewModel {
        var episodes: [SearchResultEpisode] = []
        var podcasts: [SearchResultPodcast] = []
        var curatedLists: [SearchResultCuratedList] = []
        
        model.result.forEach { model in
            switch model {
            case let .episode(episode):
                episodes.append(episode)
                
            case let .podcast(podcast):
                podcasts.append(podcast)
                
            case let .curatedList(curatedList):
                curatedLists.append(curatedList)
            }
        }
        
        return GeneralSearchContentResultViewModel(
            episodes: episodes,
            podcasts: podcasts,
            curatedLists: curatedLists
        )
    }
    
    static func map(_ model: SearchResultEpisode) -> SearchResultEpisodeViewModel {
        SearchResultEpisodeViewModel(
            title: model.titleOriginal,
            description: model.descriptionOriginal,
            thumbnail: model.thumbnail
        )
    }
    
    static func map(_ model: SearchResultPodcast) -> SearchResultPodcastViewModel {
        SearchResultPodcastViewModel(
            title: model.titleOriginal,
            publisher: model.publisherOriginal,
            thumbnail: model.thumbnail
        )
    }
    
    static func map(_ model: SearchResultCuratedList) -> SearchResultCuratedListViewModel {
        SearchResultCuratedListViewModel(
            title: model.titleOriginal,
            description: model.descriptionOriginal,
            podcasts: model.podcasts
        )
    }
}

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

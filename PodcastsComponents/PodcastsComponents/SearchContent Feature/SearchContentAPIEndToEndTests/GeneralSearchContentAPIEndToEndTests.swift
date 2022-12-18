// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import PodcastsGenresList
import SearchContentModule

final class GeneralSearchContentAPIEndToEndTests: XCTestCase, EphemeralClient {
    
    func test_endToEndTestServerGETGeneralSearchContentResult_matchesFixedTestGenresData() {
        switch fetchResult(from: testServerURL, withMapper: GeneralSearchContentMapper.map) {
        case let .success(searchResult):
            XCTAssertEqual(searchResult.result[0], .episode(expectedEpisodeObject()))
            XCTAssertEqual(searchResult.result[1], .podcast(expectedPodcastObject()))
            XCTAssertEqual(searchResult.result[2], .curatedList(expectedCuratedObject()))
            
        case let .failure(error):
            XCTFail("Expected successful genres list, but got \(error) instead")
        default:
            XCTFail("Expected successful genres list, but got no result instead")
        }
    }
    
    // MARK: - Heplers
    
    private var testServerURL: URL {
        URL(string: "https://firebasestorage.googleapis.com/v0/b/anycast-ae.appspot.com/o/Search%2FGET-general-search-content.json?alt=media&token=8c1fce58-10b4-449d-9138-c419b640fe52")!
    }
    
    private func expectedEpisodeObject() -> SearchResultEpisode {
        SearchResultEpisode(
            id: "5D948FFD-83C2-4898-86E1-42BC93E2102A",
            titleOriginal: "Episode Title",
            descriptionOriginal: "Episode  Description",
            image: URL(string: "https://a-url.com")!,
            thumbnail: URL(string: "https://a-url.com")!
        )
    }
    
    private func expectedPodcastObject() -> SearchResultPodcast {
        SearchResultPodcast(
            id: "66E2EC6C-6908-4FFE-84A3-5A244C298E77",
            titleOriginal: "Podcast Title",
            publisherOriginal: "Publisher",
            image: URL(string: "https://a-url.com")!,
            thumbnail: URL(string: "https://a-url.com")!
        )
    }
    
    private func expectedCuratedObject() -> SearchResultCuratedList {
        SearchResultCuratedList(
            id: "165E9CA1-9FFC-40D4-A04E-E95BF2003B96",
            titleOriginal: "Another Curated list title",
            descriptionOriginal: "Curated list description",
            podcasts: [
                SearchResultPodcast(
                    id: "7F06A8CF-1C70-4A1F-A4F9-E5D991E8B603",
                    titleOriginal: "Title",
                    publisherOriginal: "Publisher",
                    image: URL(string: "https://a-url.com")!,
                    thumbnail: URL(string: "https://a-url.com")!
                ),
                SearchResultPodcast(
                    id: "D9D904E6-FAF9-455F-AE16-4604367A16E5",
                    titleOriginal: "Another Title",
                    publisherOriginal: "Another Publisher",
                    image: URL(string: "https://a-url.com")!,
                    thumbnail: URL(string: "https://a-url.com")!
                )
            ]
        )
    }
}

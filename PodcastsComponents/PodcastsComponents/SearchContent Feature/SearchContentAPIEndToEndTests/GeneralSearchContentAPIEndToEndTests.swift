// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import PodcastsGenresList
import SearchContentModule

final class GeneralSearchContentAPIEndToEndTests: XCTestCase, EphemeralClient {
    
    func test_endToEndTestServerGETGeneralSearchContentResult_matchesFixedTestSearchData() {
        switch fetchResult(from: testServerURL, withMapper: GeneralSearchContentMapper.map) {
        case let .success(searchResult):
            XCTAssertEqual(searchResult.result[0], .episode(expectedEpisodeObject()))
            XCTAssertEqual(searchResult.result[1], .podcast(expectedPodcastObject()))
            XCTAssertEqual(searchResult.result[2], .curatedList(expectedCuratedObject()))
            
        case let .failure(error):
            XCTFail("Expected successful search result, but got \(error) instead")
        default:
            XCTFail("Expected successful search result, but got no result instead")
        }
    }
    
    // MARK: - Heplers
    
    private var testServerURL: URL {
        URL(string: "https://firebasestorage.googleapis.com/v0/b/anycast-ae.appspot.com/o/Search%2FGET-general-search-content.json?alt=media&token=a69e3045-e600-41ba-8b97-5f60de8d2ea6")!
    }
    
    private func expectedEpisodeObject() -> Episode {
        Episode(
            id: "c877bf360bda4c74adea2ba066df6929",
            title: "Star Wars Theory: The Great Star Wars Ice Cream Conspiracy",
            description: "Description of Star Wars Theory: The Great Star Wars Ice Cream Conspiracy",
            thumbnail: URL(string: "https://production.listennotes.com/podcasts/super-carlin-brothers-j-and-ben-carlin-TSfxiBaqOwK-BodDr7iIAR3.300x300.jpg")!,
            audio: URL(string: "https://www.listennotes.com/e/p/c877bf360bda4c74adea2ba066df6929/")!,
            audioLengthInSeconds: 638,
            containsExplicitContent: false,
            publishDateInMiliseconds: 1574355600265
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

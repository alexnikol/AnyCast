// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import PodcastsGenresList
import SearchContentModule

final class TypeheadSearchContentAPIEndToEndTests: XCTestCase, EphemeralClient {
    
    func test_endToEndTestServerGETTypeHeadSearchContentResult_matchesFixedTestGenresData() {
        switch fetchResult(from: testServerURL, withMapper: TypeheadSearchContentMapper.map) {
        case let .success(searchResult):
            XCTAssertEqual(searchResult.terms.count, 3, "Expected 3 searched terms in search result")
            XCTAssertEqual(searchResult.genres.count, 2, "Expected 2 searched genres in search result")
            XCTAssertEqual(searchResult.podcasts.count, 2, "Expected 2 searched podcasts in search result")
            
            XCTAssertEqual(searchResult.terms[0], expectedSearchTerm(at: 0))
            XCTAssertEqual(searchResult.terms[1], expectedSearchTerm(at: 1))
            XCTAssertEqual(searchResult.terms[2], expectedSearchTerm(at: 2))
            
            XCTAssertEqual(searchResult.genres[0], expectedGenre(at: 0))
            XCTAssertEqual(searchResult.genres[1], expectedGenre(at: 1))
            
            XCTAssertEqual(searchResult.podcasts[0], expectedSearchPodcast(at: 0))
            XCTAssertEqual(searchResult.podcasts[1], expectedSearchPodcast(at: 1))
            
        case let .failure(error):
            XCTFail("Expected successful genres list, but got \(error) instead")
        default:
            XCTFail("Expected successful genres list, but got no result instead")
        }
    }
    
    // MARK: - Heplers
    
    private var testServerURL: URL {
        URL(string: "https://firebasestorage.googleapis.com/v0/b/anycast-ae.appspot.com/o/Search%2Ftypeahead-content-search.json?alt=media&token=7858fcb3-4b56-4270-8c62-26a842690fe6")!
    }
    
    private func expectedSearchTerm(at index: Int) -> String {
        return [
            "star wars",
            "star troopers",
            "starlord"
        ][index]
    }
    
    private func expectedGenre(at index: Int) -> Genre {
        func id(at index: Int) -> Int {
            return [
                160, 161
            ][index]
        }
        
        func name(at index: Int) -> String {
            return [
                "Star Wars",
                "Star Track"
            ][index]
        }
        
        return Genre(
            id: id(at: index),
            name: name(at: index)
        )
    }
    
    private func expectedSearchPodcast(at index: Int) -> PodcastSearchResult {
        func id(at index: Int) -> String {
            return [
                "ca3b35271db04291ba56fab8a4f731e4",
                "8e90b8f0c9eb4c11b13f9dc331ed747c",
            ][index]
        }
        
        func titleOriginal(at index: Int) -> String {
            return [
                "Rebel Force Radio: Star Wars Podcast",
                "Inside Star Wars"
            ][index]
        }
        
        func publisherOriginal(at index: Int) -> String {
            return [
                "Star Wars",
                "Wondery"
            ][index]
        }
        
        func image(at index: Int) -> URL {
            let baseURL = URL(string: "https://production.listennotes.com/podcasts")!
            return [
                baseURL.appendingPathComponent("rebel-force-radio-star-wars-podcast-star-wars-GSQTPOZCqAx-4v5pRaEg1Ub.1400x1400.jpg"),
                baseURL.appendingPathComponent("inside-star-wars-wondery-F8ZBEqObITM-e8ydUYnAOJv.1400x1400.jpg")
            ][index]
        }
        
        func thumbnail(at index: Int) -> URL {
            let baseURL = URL(string: "https://production.listennotes.com/podcasts")!
            return [
                baseURL.appendingPathComponent("rebel-force-radio-star-wars-podcast-star-wars-Na1ogntxKO_-4v5pRaEg1Ub.300x300.jpg"),
                baseURL.appendingPathComponent("inside-star-wars-wondery-2Ep_n06B8ad-e8ydUYnAOJv.300x300.jpg")
            ][index]
        }
        
        return SearchResultPodcast(
            id: id(at: index),
            titleOriginal: titleOriginal(at: index),
            publisherOriginal: publisherOriginal(at: index),
            image: image(at: index),
            thumbnail: thumbnail(at: index)
        )
    }
}

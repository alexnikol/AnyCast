// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import PodcastsGenresList

final class BestPodcastsEndpointTests: XCTestCase {
    
    func test_podcastDetails_endpointURL() {
        let baseURL = URL(string: "https://listen-api-test.listennotes.com")!
        let received = GenresEndpoint.getGenres.url(baseURL: baseURL)
        let exptected = URL(string: "https://listen-api-test.listennotes.com/api/v2/genres")
        
        XCTAssertEqual(received, exptected)
    }
}

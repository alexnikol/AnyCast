// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import PodcastsModule

class BestPodcastsEndpointTests: XCTestCase {
    
    func test_podcastDetails_endpointURL() {
        let baseURL = URL(string: "https://listen-api-test.listennotes.com")!
        let genreID = 1
        let received = PodcastsEndpoint.getBestPodcasts(genreID: genreID).url(baseURL: baseURL)
        let exptected = URL(string: "https://listen-api-test.listennotes.com/api/v2/best_podcasts?genre_id=\(genreID)")
        
        XCTAssertEqual(received, exptected)
    }
}

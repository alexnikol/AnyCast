// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import PodcastsModule

class PodcastsEndpointTests: XCTestCase {
    
    func test_podcastDetails_endpointURL() {
        let baseURL = URL(string: "https://listen-api-test.listennotes.com")!
        let podcastID = UUID().uuidString
        let received = PodcastsEndpoint.get(podcastID: podcastID).url(baseURL: baseURL)
        let exptected = URL(string: "https://listen-api-test.listennotes.com/api/v2/podcasts/\(podcastID)")
        
        XCTAssertEqual(received, exptected)
    }
}

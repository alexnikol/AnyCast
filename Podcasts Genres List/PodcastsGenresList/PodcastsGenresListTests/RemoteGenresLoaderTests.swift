//
//  RemoteGenresLoaderTests.swift
//  PodcastsGenresListTests
//
//  Created by Alexander Nikolaychuk on 31.08.2022.
//

import XCTest

class RemoteGenresLoader {
    
}

class HTTPClient {
    var requestedURL: URL?
}

class RemoteGenresLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClient()
        _ = RemoteGenresLoader()
        
        XCTAssertNil(client.requestedURL)
    }
}

//
//  RemoteGenresLoaderTests.swift
//  PodcastsGenresListTests
//
//  Created by Alexander Nikolaychuk on 31.08.2022.
//

import XCTest

class RemoteGenresLoader {
    
    func load() {
        HTTPClient.shared.requestedURL = URL(string: "http://a-url.com")
    }
}

class HTTPClient {
    var requestedURL: URL?
    
    static let shared = HTTPClient()
    
    private init() {}
}

class RemoteGenresLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClient.shared
        _ = RemoteGenresLoader()
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDataFromURL() {
        let client = HTTPClient.shared
        let sut = RemoteGenresLoader()
        
        sut.load()
        
        XCTAssertNotNil(client.requestedURL)
    }
}

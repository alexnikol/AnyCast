//
//  RemoteGenresLoaderTests.swift
//  PodcastsGenresListTests
//
//  Created by Alexander Nikolaychuk on 31.08.2022.
//

import XCTest
import PodcastsGenresList

class RemoteGenresLoaderTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertNil(client.requestedURL)
    }
    
    func test_load_requestDataFromURL() {
        let url = URL(string: "http://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
        
        XCTAssertEqual(client.requestedURL, url)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "http://a-url.com")!) -> (loader: RemoteGenresLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteGenresLoader(url: url, client: client)
        return (sut, client)
    }
    
    private final class HTTPClientSpy: HTTPClient {
        var requestedURL: URL?
        
        func get(from url: URL) {
            requestedURL = url
        }
    }
}

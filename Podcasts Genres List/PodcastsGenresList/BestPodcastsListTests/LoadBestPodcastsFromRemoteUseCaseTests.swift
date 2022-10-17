// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import BestPodcastsList
import PodcastsGenresList

class RemoteBestPodcastsLoader {
    
    private let client: HTTPClient
    private let url: URL
    
    init(genreID: Int, url: URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }
    
    func load(completion: @escaping (BestPodcastsLoader.Result) -> Void) {
        client.get(from: url) { result in
            
        }
    }
}

class LoadBestPodcastsFromRemoteUseCaseTests: LoadGenresFromRemoteUseCaseTests {
    
    override func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    override func test_load_requestsDataFromURL() {
        let url = URL(string: "http://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    override func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "http://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        url: URL = URL(string: "http://a-url.com")!,
        file: StaticString = #file,
        line: UInt = #line
    ) -> (loader: RemoteBestPodcastsLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let anyGenreID = 1
        let sut = RemoteBestPodcastsLoader(genreID: anyGenreID, url: url, client: client)
        
        trackForMemoryLeaks(sut)
        trackForMemoryLeaks(client)
        return (sut, client)
    }
}

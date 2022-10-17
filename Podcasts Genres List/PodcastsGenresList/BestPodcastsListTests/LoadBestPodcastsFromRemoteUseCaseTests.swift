// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import BestPodcastsList
import PodcastsGenresList

class RemoteBestPodcastsLoader {
    
    init(url: URL, client: HTTPClient) {}
}

class LoadBestPodcastsFromRemoteUseCaseTests: LoadGenresFromRemoteUseCaseTests {
    
    override func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        url: URL = URL(string: "http://a-url.com")!,
        file: StaticString = #file,
        line: UInt = #line
    ) -> (loader: RemoteBestPodcastsLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteBestPodcastsLoader(url: url, client: client)
        
        trackForMemoryLeaks(sut)
        trackForMemoryLeaks(client)
        return (sut, client)
    }
}

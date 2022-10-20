// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import BestPodcastsList

class CacheImageDataUseCaseTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertTrue(store.receivedMessages.isEmpty)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: LocalPodcastsImageDataLoader, store: PodcastsImageDataStoreSpy) {
        let store = PodcastsImageDataStoreSpy()
        let sut = LocalPodcastsImageDataLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
        
    func failure(_ error: LocalPodcastsImageDataLoader.Error) -> Result<Data, Error> {
        return .failure(error)
    }
}

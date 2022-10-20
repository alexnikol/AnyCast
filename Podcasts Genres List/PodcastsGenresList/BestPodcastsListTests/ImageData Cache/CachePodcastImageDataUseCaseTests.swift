// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import BestPodcastsList

class CachePodcastImageDataUseCaseTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertTrue(store.receivedMessages.isEmpty)
    }
    
    func test_saveImageDataForURL_requestImageDataInsertionForURL() {
        let (sut, store) = makeSUT()
        let url = anyURL()
        let data = anyData()
        
        sut.save(data, for: url, completion: { _ in })
        
        XCTAssertEqual(store.receivedMessages, [.insert(data: data, for: url)])
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

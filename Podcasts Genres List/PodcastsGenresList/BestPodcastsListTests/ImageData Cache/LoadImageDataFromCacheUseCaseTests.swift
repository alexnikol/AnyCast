// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest

class LocalPodcastsImageDataLoader {
    
    init(store: Any) {}
}

class LoadImageDataFromCacheUseCaseTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertTrue(store.receivedMessages.isEmpty)
    }
    
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) -> (sut: LocalPodcastsImageDataLoader, store: StoreSpy) {
        let store = StoreSpy()
        let sut = LocalPodcastsImageDataLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private class StoreSpy {
        private(set) var receivedMessages: [Any] = []
    }
}

// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import SharedTestHelpersLibrary

final class LocalPlaybackProgressLoader {
    
    init(store: PlaybackProgressStore, currentDate: @escaping () -> Date) {}
}

protocol PlaybackProgressStore {
    
}

class PlaybackProgressStoreSpy: PlaybackProgressStore {
    private(set) var receivedMessages: [Int] = []
}

final class CachePlaybackProgressUseCaseTests: XCTestCase {
    
    func test_init_doesNotMessageStoreCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    private func makeSUT(
        currentDate: @escaping () -> Date = Date.init,
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: LocalPlaybackProgressLoader, store: PlaybackProgressStoreSpy) {
        let store = PlaybackProgressStoreSpy()
        let sut = LocalPlaybackProgressLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
}

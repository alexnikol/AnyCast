// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import PodcastsModule

class PlayingEpisodeService {
    private let store: PlayingEpisodeStore
    
    init(store: PlayingEpisodeStore) {
        self.store = store
    }
}

protocol PlayingEpisodeStore {}

class PlayingEpisodeServiceTests: XCTestCase {
    
    func test_init() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.messages, [])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: PlayingEpisodeService, store: PlayingEpisodeStoreSpy) {
        let store = PlayingEpisodeStoreSpy()
        let sut = PlayingEpisodeService(store: store)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(store, file: file, line: line)
        return (sut, store)
    }
}

private class PlayingEpisodeStoreSpy: PlayingEpisodeStore {
    var messages: [Int] = []
}

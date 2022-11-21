// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import PodcastsModule

class PlayingEpisodeService {
    private let store: PlayingEpisodeStore
    
    init(store: PlayingEpisodeStore) {
        self.store = store
    }
    
    func load(completion: @escaping (Result<Episode, Error>) -> Void) {
        store.retrieve(completion: { _ in })
    }
}

protocol PlayingEpisodeStore {
    func retrieve(completion: @escaping (Result<Episode, Error>) -> Void)
}

class PlayingEpisodeServiceTests: XCTestCase {
    
    func test_init() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_load_requestsCacheRetrieval() {
        let (sut, store) = makeSUT()
        
        sut.load { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
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
    enum Message: Equatable {
        case retrieve
    }
    
    var receivedMessages: [Message] = []
    
    func retrieve(completion: @escaping (Result<Episode, Error>) -> Void) {
        receivedMessages.append(.retrieve)
    }
}

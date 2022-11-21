// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import PodcastsModule

class PlayingEpisodeService {
    
}

protocol PlayingEpisodeStore {}

class PlayingEpisodeServiceTests: XCTestCase {
    
    func test_init() {
        let sut = PlayingEpisodeService()
        let store = PlayingEpisodeStoreSpy()
        
        XCTAssertEqual(store.messages, [])
    }
}

private class PlayingEpisodeStoreSpy: PlayingEpisodeStore {
    var messages: [Int] = []
}

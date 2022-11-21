// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest

class PlayerStateService {
    
}

protocol LastPlayedEpisodeStore {
    
}

class PlayerStateServiceTests: XCTestCase {
    
    func test_init_doesNotRequestsLastPlayedEpisodeStoreWithoutAnySubscriber() {
        let sut = PlayerStateService()
        let store = LastPlayedEpisodeStoreSpy()
        
        XCTAssertTrue(store.receivedMessages.isEmpty)
    }
    
    private class LastPlayedEpisodeStoreSpy: LastPlayedEpisodeStore {
        enum Message {}
        
        private(set) var receivedMessages: [Message] = []
    }
}

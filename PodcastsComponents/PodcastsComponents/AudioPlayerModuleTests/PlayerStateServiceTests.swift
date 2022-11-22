// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import PodcastsModule

struct CurrentPlayerState {
    let data: Int
}

protocol AudioPlayerObserver {
    func update(with playerState: CurrentPlayerState)
}

class PlayerStateServiceTests: XCTestCase {
    
    func test_init_doesNotDeliversValueOnCreation() {
        var receivedData: CurrentPlayerState?
        _ = ConcreteAudioPlayerObserver(onReceiveUpdates: { state in
            receivedData = state
        })
        
        XCTAssertNil(receivedData)
    }
    
    private class ConcreteAudioPlayerObserver: AudioPlayerObserver {
        var onReceiveUpdates: (CurrentPlayerState) -> Void
        
        init(onReceiveUpdates: @escaping (CurrentPlayerState) -> Void) {
            self.onReceiveUpdates = onReceiveUpdates
        }
        
        func update(with playerState: CurrentPlayerState) {
            
        }
    }
}

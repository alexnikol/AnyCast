// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import PodcastsModule

enum CurrentPlayerState {
    case noPlayingItem
}

protocol AudioPlayerObserver {
    func update(with playerState: CurrentPlayerState)
}

protocol AudioPlayerStateSubject {
    func attach(observer: AudioPlayerObserver)
}

class PlayerStateServiceTests: XCTestCase {
    
    func test_init_doesNotDeliversValueOnCreationWithoutSubscription() {
        var receivedData: CurrentPlayerState?
        _ = AudioPlayerStateObserver(onReceiveUpdates: { state in
            receivedData = state
        })
        
        XCTAssertNil(receivedData)
    }
    
    func test_onReceiveValues_deliversStateAfterSubscription() {
        let playerSubject = AudioPlayerStateSubjectSpy()
        var receivedPlayerState: CurrentPlayerState?
        let exp = expectation(description: "Wait on receive state")
        let observer = AudioPlayerStateObserver(onReceiveUpdates: { state in
            receivedPlayerState = state
            exp.fulfill()
        })
        
        playerSubject.attach(observer: observer)
        playerSubject.receiveNewPlayerState(.noPlayingItem)
        
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(receivedPlayerState, .noPlayingItem)
    }
    
    func test_onReceiveValues_deliversPreviousStateAfterSubscription() {
        let playerSubject = AudioPlayerStateSubjectSpy()
        var receivedPlayerState: CurrentPlayerState?
        let exp = expectation(description: "Wait on receive state")
        let observer = AudioPlayerStateObserver(onReceiveUpdates: { state in
            receivedPlayerState = state
            exp.fulfill()
        })
        
        playerSubject.receiveNewPlayerState(.noPlayingItem)
        playerSubject.attach(observer: observer)
        
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(receivedPlayerState, .noPlayingItem)
    }
    
    // MARK: - Helpers
    
    private class AudioPlayerStateObserver: AudioPlayerObserver {
        var onReceiveUpdates: (CurrentPlayerState) -> Void
        
        init(onReceiveUpdates: @escaping (CurrentPlayerState) -> Void) {
            self.onReceiveUpdates = onReceiveUpdates
        }
        
        func update(with playerState: CurrentPlayerState) {
            onReceiveUpdates(playerState)
        }
    }
    
    private class AudioPlayerStateSubjectSpy: AudioPlayerStateSubject {
        
        private var previosState: CurrentPlayerState?
        private var observer: AudioPlayerObserver?
        
        func attach(observer: AudioPlayerObserver) {
            self.observer = observer
            updateStateOfAttachedObserverIfPreviousStateExists(observer)
        }
        
        func receiveNewPlayerState(_ state: CurrentPlayerState) {
            previosState = state
            updateObserver(with: state)
        }
        
        private func updateObserver(with state: CurrentPlayerState) {
            observer?.update(with: state)
        }
        
        private func updateStateOfAttachedObserverIfPreviousStateExists(_ observer: AudioPlayerObserver) {
            guard let previosState = previosState else {
                return
            }
            updateObserver(with: previosState)
        }
    }
}

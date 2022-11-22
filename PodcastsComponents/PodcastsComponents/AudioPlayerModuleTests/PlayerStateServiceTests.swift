// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import PodcastsModule

enum CurrentPlayerState {
    case noPlayingItem
}

protocol AudioPlayerObserver {
    func receive(_ playerState: CurrentPlayerState)
}

protocol AudioPlayerStatePublisher {
    func subscribe(observer: AudioPlayerObserver)
}

class AudioPlayerStateObserver: AudioPlayerObserver {
    var onReceiveUpdates: (CurrentPlayerState) -> Void
    
    init(onReceiveUpdates: @escaping (CurrentPlayerState) -> Void) {
        self.onReceiveUpdates = onReceiveUpdates
    }
    
    func receive(_ playerState: CurrentPlayerState) {
        onReceiveUpdates(playerState)
    }
}

class PlayerStateServiceTests: XCTestCase {
    
    func test_init_doesNotDeliversValueOnCreationWithoutSubscription() {
        var receivedPlayerState: CurrentPlayerState?
        
        _ = makeSUT { state in
            receivedPlayerState = state
        }
        
        XCTAssertNil(receivedPlayerState)
    }
    
    func test_onReceiveValues_deliversStateAfterSubscription() {
        var receivedPlayerState: CurrentPlayerState?
        
        let exp = expectation(description: "Wait on receive state")
        let (sut, publisher) = makeSUT { state in
            receivedPlayerState = state
            exp.fulfill()
        }
        publisher.subscribe(observer: sut)
        publisher.receiveNewPlayerState(.noPlayingItem)
        
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(receivedPlayerState, .noPlayingItem)
    }
    
    func test_onReceiveValues_deliversPreviousStateAfterSubscription() {
        var receivedPlayerState: CurrentPlayerState?
        
        let exp = expectation(description: "Wait on receive state")
        let (sut, publisher) = makeSUT { state in
            receivedPlayerState = state
            exp.fulfill()
        }
        
        publisher.receiveNewPlayerState(.noPlayingItem)
        publisher.subscribe(observer: sut)
        
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(receivedPlayerState, .noPlayingItem)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        onReceiveUpdates: @escaping (CurrentPlayerState) -> Void,
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: AudioPlayerStateObserver, publisher: AudioPlayerStatePublisherSpy) {
        let publisher = AudioPlayerStatePublisherSpy()
        let sut = AudioPlayerStateObserver(onReceiveUpdates: onReceiveUpdates)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(publisher, file: file, line: line)
        return (sut, publisher)
    }
    
    private class AudioPlayerStatePublisherSpy: AudioPlayerStatePublisher {
        
        private var previosState: CurrentPlayerState?
        private var observer: AudioPlayerObserver?
        
        func subscribe(observer: AudioPlayerObserver) {
            self.observer = observer
            updateStateOfAttachedObserverIfPreviousStateExists(observer)
        }
        
        func receiveNewPlayerState(_ state: CurrentPlayerState) {
            previosState = state
            updateObserver(with: state)
        }
        
        private func updateObserver(with state: CurrentPlayerState) {
            observer?.receive(state)
        }
        
        private func updateStateOfAttachedObserverIfPreviousStateExists(_ observer: AudioPlayerObserver) {
            guard let previosState = previosState else {
                return
            }
            updateObserver(with: previosState)
        }
    }
}

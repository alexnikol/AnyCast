// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import AudioPlayerModule

final class AudioPlayerStatePublisherTests: XCTestCase {
    
    func test_init_doesNotDeliversValueOnCreationWithoutSubscription() {
        var receivedPlayerState: PlayerState?
        
        _ = makeObserver { state in
            receivedPlayerState = state
        }
        
        XCTAssertNil(receivedPlayerState)
    }
    
    func test_onReceiveValues_deliversStateAfterSubscription() {
        let (sut, audioPlayer) = makeSUT()
        let observer = makeObserver()
        
        expect(observer, expectedResult: [.noPlayingItem], when: {
            _ = sut.subscribe(observer: observer)
            audioPlayer.receiveNewPlayerState(.noPlayingItem)
        })
    }
    
    func test_onReceiveValues_deliversPreviousStateAfterSubscription() {
        let (sut, audioPlayer) = makeSUT()
        let observer = makeObserver()
        
        expect(observer, expectedResult: [.noPlayingItem], when: {
            audioPlayer.receiveNewPlayerState(.noPlayingItem)
            _ = sut.subscribe(observer: observer)
        })
    }
    
    func test_onReceiveValues_deliversMoreThenOneStateAfterSubscription() {
        let (sut, audioPlayer) = makeSUT()
        let observer = makeObserver()
        
        let playingItem = makePlayingItem()
        let updatedPlayingItem = makePlayingItem()
        
        expect(
            observer,
            expectedResult: [.noPlayingItem, .startPlayingNewItem(playingItem), .updatedPlayingItem(updatedPlayingItem)],
            when: {
                _ = sut.subscribe(observer: observer)
                audioPlayer.receiveNewPlayerState(.noPlayingItem)
                audioPlayer.receiveNewPlayerState(.startPlayingNewItem(playingItem))
                audioPlayer.receiveNewPlayerState(.updatedPlayingItem(updatedPlayingItem))
            }
        )
    }
    
    func test_onReceiveValues_doesNotDeliversStateUpdatesAfterUnsubscribe() {
        let (sut, audioPlayer) = makeSUT()
        let observer = makeObserver()
        
        expect(observer, expectedResult: [.noPlayingItem], when: {
            let subscription = sut.subscribe(observer: observer)
            audioPlayer.receiveNewPlayerState(.noPlayingItem)
            
            subscription.unsubscribe()
            audioPlayer.receiveNewPlayerState(.startPlayingNewItem(makePlayingItem()))
        })
    }
    
    func test_onReceiveValues_deliversTheSameValueToMultipleObserversAndStopDeliverAfterUnsubscribe() {
        let (sut, audioPlayer) = makeSUT()
        let observer1 = makeObserver()
        let observer2 = makeObserver()
        
        var receivedStateObserver1: [PlayerState] = []
        let exp1 = expectation(description: "Wait on receive state")
        exp1.assertForOverFulfill = false
        
        observer1.onReceiveUpdates = { state in
            receivedStateObserver1.append(state)
            exp1.fulfill()
        }
        
        var receivedStateObserver2: [PlayerState] = []
        let exp2 = expectation(description: "Wait on receive state")
        exp2.assertForOverFulfill = false
        
        observer2.onReceiveUpdates = { state in
            receivedStateObserver2.append(state)
            exp2.fulfill()
        }
        
        let subscription1 = sut.subscribe(observer: observer1)
        _ = sut.subscribe(observer: observer2)
        
        audioPlayer.receiveNewPlayerState(.noPlayingItem)
        audioPlayer.receiveNewPlayerState(.noPlayingItem)
        
        waitForExpectations(timeout: 1.0)
        
        XCTAssertEqual(receivedStateObserver1, [.noPlayingItem, .noPlayingItem])
        XCTAssertEqual(receivedStateObserver2, [.noPlayingItem, .noPlayingItem])
        
        subscription1.unsubscribe()
        
        audioPlayer.receiveNewPlayerState(.noPlayingItem)
        audioPlayer.receiveNewPlayerState(.noPlayingItem)
        
        XCTAssertEqual(receivedStateObserver1, [.noPlayingItem, .noPlayingItem])
        XCTAssertEqual(receivedStateObserver2, [.noPlayingItem, .noPlayingItem, .noPlayingItem, .noPlayingItem])
    }
    
    // MARK: - Helpers
    
    private func makeObserver(
        onReceiveUpdates: @escaping (PlayerState) -> Void = { _ in },
        file: StaticString = #file,
        line: UInt = #line
    ) -> AudioPlayerStateObserverSpy {
        let sut = AudioPlayerStateObserverSpy(onReceiveUpdates: onReceiveUpdates)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> (AudioPlayerStatePublisher, AudioPlayerDummy) {
        let publisher = AudioPlayerStatePublisher()
        let audioPlayer = AudioPlayerDummy(delegate: publisher)
        trackForMemoryLeaks(publisher, file: file, line: line)
        return (publisher, audioPlayer)
    }
    
    private func expect(
        _ sut: AudioPlayerStateObserverSpy,
        expectedResult: [PlayerState],
        when action: () -> Void,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        var receivedPlayerStates: [PlayerState] = []
        
        let exp = expectation(description: "Wait on receive state")
        exp.assertForOverFulfill = false
        
        sut.onReceiveUpdates = { state in
            receivedPlayerStates.append(state)
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(expectedResult, receivedPlayerStates, file: file, line: line)
    }
    
    private func makePlayingItem() -> PlayingItem {
        PlayingItem(
            episode: makeUniqueEpisode(),
            podcast: makePodcast(),
            updates: [
                .playback(.playing),
                .progress(
                    .init(
                        currentTimeInSeconds: 10,
                        totalTime: .notDefined,
                        progressTimePercentage: 0.1
                    )
                ),
                .volumeLevel(0.5)
            ]
        )
    }
    
    private class AudioPlayerStateObserverSpy: AudioPlayerObserver {
        var onReceiveUpdates: (PlayerState) -> Void
        
        init(onReceiveUpdates: @escaping (PlayerState) -> Void) {
            self.onReceiveUpdates = onReceiveUpdates
        }
        
        func receive(_ playerState: PlayerState) {
            onReceiveUpdates(playerState)
        }
        
        func prepareForSeek(_ progress: AudioPlayerModule.PlayingItem.Progress) {}
    }
    
    private class AudioPlayerDummy: AudioPlayer {
        var isPlaying = false
        var delegate: AudioPlayerOutputDelegate?
        
        init(delegate: AudioPlayerOutputDelegate?) {
            self.delegate = delegate
        }
        
        func receiveNewPlayerState(_ state: PlayerState) {
            delegate?.didUpdateState(with: state)
        }
        
        func startPlayback(fromURL url: URL, withMeta meta: AudioPlayerModule.Meta) {}
        
        func play() {}
        
        func pause() {}
        
        func changeVolumeTo(value: Float) {}
        
        func seekToProgress(_ progress: Float) {}
        
        func seekToSeconds(_ seconds: Int) {}
        
        func changeSpeedPlaybackTo(value: AudioPlayerModule.PlaybackSpeed) {}
        
        func prepareForSeek(_ progress: Float) {}
    }
}

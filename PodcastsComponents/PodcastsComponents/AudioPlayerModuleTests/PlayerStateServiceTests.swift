// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import PodcastsModule

struct PlayingItem: Equatable {
    enum PlaybackState: Equatable {
        case playing
        case pause
        case loading
    }
    
    struct State: Equatable {
        let playbackState: PlaybackState
        let currentTimeInSeconds: Int
        let totalTimeInSeconds: Int
        let progressTimePercentage: Double
        let volumeLevel: Double
    }
    
    let episode: Episode
    let state: State
}

enum CurrentPlayerState: Equatable {
    case noPlayingItem
    case updatedPlayingItem(PlayingItem)
    case startPlayingNewItem(PlayingItem)
}

protocol AudioPlayerObserver {
    func receive(_ playerState: CurrentPlayerState)
}

protocol AudioPlayerStatePublisher {
    func subscribe(observer: AudioPlayerObserver)
    func unsubscribe(observer: AudioPlayerObserver)
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
        let publisher = makePublisher()
        let observer = makeSUT()
        
        expect(observer, expectedResult: [.noPlayingItem], when: {
            publisher.subscribe(observer: observer)
            publisher.receiveNewPlayerState(.noPlayingItem)
        })
    }
    
    func test_onReceiveValues_deliversPreviousStateAfterSubscription() {
        let publisher = makePublisher()
        let observer = makeSUT()
        
        expect(observer, expectedResult: [.noPlayingItem], when: {
            publisher.receiveNewPlayerState(.noPlayingItem)
            publisher.subscribe(observer: observer)
        })
    }
    
    func test_onReceiveValues_deliversMoreThenOneStateAfterSubscription() {
        let publisher = makePublisher()
        let observer = makeSUT()
        
        let playingItem = makePlayingItem()
        let updatedPlayingItem = makePlayingItem()
        
        expect(
            observer,
            expectedResult: [.noPlayingItem, .startPlayingNewItem(playingItem), .updatedPlayingItem(updatedPlayingItem)],
            when: {
                publisher.subscribe(observer: observer)
                publisher.receiveNewPlayerState(.noPlayingItem)
                publisher.receiveNewPlayerState(.startPlayingNewItem(playingItem))
                publisher.receiveNewPlayerState(.updatedPlayingItem(updatedPlayingItem))
            }
        )
    }
    
    func test_onReceiveValues_doesNotDeliversStateUpdatesAfterUnsubscribe() {
        let publisher = makePublisher()
        let observer = makeSUT()
        
        expect(observer, expectedResult: [.noPlayingItem], when: {
            publisher.subscribe(observer: observer)
            publisher.receiveNewPlayerState(.noPlayingItem)
            
            publisher.unsubscribe(observer: observer)
            publisher.receiveNewPlayerState(.startPlayingNewItem(makePlayingItem()))
        })
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        onReceiveUpdates: @escaping (CurrentPlayerState) -> Void = { _ in },
        file: StaticString = #file,
        line: UInt = #line
    ) -> AudioPlayerStateObserver {
        let sut = AudioPlayerStateObserver(onReceiveUpdates: onReceiveUpdates)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func makePublisher(
        file: StaticString = #file,
        line: UInt = #line
    ) -> AudioPlayerStatePublisherSpy {
        let publisher = AudioPlayerStatePublisherSpy()
        trackForMemoryLeaks(publisher, file: file, line: line)
        return publisher
    }
    
    private func expect(
        _ sut: AudioPlayerStateObserver,
        expectedResult: [CurrentPlayerState],
        when action: () -> Void,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        var receivedPlayerStates: [CurrentPlayerState] = []
        
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
            state: PlayingItem.State(
                playbackState: .playing,
                currentTimeInSeconds: 10,
                totalTimeInSeconds: 100,
                progressTimePercentage: 0.1,
                volumeLevel: 0.5
            )
        )
    }
    
    func makeUniqueEpisode(publishDate: Date = Date(), audioLengthInSeconds: Int = 100) -> Episode {
        let publishDateInMiliseconds = Int(publishDate.timeIntervalSince1970) * 1000
        let episode = Episode(
            id: UUID().uuidString,
            title: "Any Episode title",
            description: "<strong>Any Episode description</strong>",
            thumbnail: anyURL(),
            audio: anyURL(),
            audioLengthInSeconds: audioLengthInSeconds,
            containsExplicitContent: false,
            publishDateInMiliseconds: publishDateInMiliseconds
        )
        return episode
    }
    
    private func anyURL() -> URL {
        URL(string: "http://a-url.com")!
    }
    
    private class AudioPlayerStatePublisherSpy: AudioPlayerStatePublisher {
        
        private var previosState: CurrentPlayerState?
        private var observer: AudioPlayerObserver?
        
        func subscribe(observer: AudioPlayerObserver) {
            self.observer = observer
            updateStateOfAttachedObserverIfPreviousStateExists(observer)
        }
        
        func unsubscribe(observer: AudioPlayerObserver) {
            self.observer = nil
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

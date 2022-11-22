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

protocol AudioPlayerStateSubscription {
    func unsubscribe()
}

protocol AudioPlayerStatePublisher {
    func subscribe(observer: AudioPlayerObserver) -> AudioPlayerStateSubscription
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
            _ = publisher.subscribe(observer: observer)
            publisher.receiveNewPlayerState(.noPlayingItem)
        })
    }
    
    func test_onReceiveValues_deliversPreviousStateAfterSubscription() {
        let publisher = makePublisher()
        let observer = makeSUT()
        
        expect(observer, expectedResult: [.noPlayingItem], when: {
            publisher.receiveNewPlayerState(.noPlayingItem)
            _ = publisher.subscribe(observer: observer)
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
                _ = publisher.subscribe(observer: observer)
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
            let subscription = publisher.subscribe(observer: observer)
            publisher.receiveNewPlayerState(.noPlayingItem)
            
            subscription.unsubscribe()
            publisher.receiveNewPlayerState(.startPlayingNewItem(makePlayingItem()))
        })
    }
    
    func test_onReceiveValues_deliversTheSameValueToMultipleObserversAndStopDeliverAfterUnsubscribe() {
        let publisher = makePublisher()
        let observer1 = makeSUT()
        let observer2 = makeSUT()
        
        var receivedStateObserver1: [CurrentPlayerState] = []
        let exp1 = expectation(description: "Wait on receive state")
        exp1.assertForOverFulfill = false
        
        observer1.onReceiveUpdates = { state in
            receivedStateObserver1.append(state)
            exp1.fulfill()
        }
        
        var receivedStateObserver2: [CurrentPlayerState] = []
        let exp2 = expectation(description: "Wait on receive state")
        exp2.assertForOverFulfill = false
        
        observer2.onReceiveUpdates = { state in
            receivedStateObserver2.append(state)
            exp2.fulfill()
        }
                
        let subscription1 = publisher.subscribe(observer: observer1)
        _ = publisher.subscribe(observer: observer2)
        
        publisher.receiveNewPlayerState(.noPlayingItem)
        publisher.receiveNewPlayerState(.noPlayingItem)
        
        waitForExpectations(timeout: 1.0)
        
        XCTAssertEqual(receivedStateObserver1, [.noPlayingItem, .noPlayingItem])
        XCTAssertEqual(receivedStateObserver2, [.noPlayingItem, .noPlayingItem])
        
        subscription1.unsubscribe()
        
        publisher.receiveNewPlayerState(.noPlayingItem)
        publisher.receiveNewPlayerState(.noPlayingItem)
        
        XCTAssertEqual(receivedStateObserver1, [.noPlayingItem, .noPlayingItem])
        XCTAssertEqual(receivedStateObserver2, [.noPlayingItem, .noPlayingItem, .noPlayingItem, .noPlayingItem])
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
        struct StateSubscription: AudioPlayerStateSubscription {
            let onUnsubscribe: () -> Void
            
            init(onUnsubscribe: @escaping () -> Void) {
                self.onUnsubscribe = onUnsubscribe
            }
            
            func unsubscribe() {
                onUnsubscribe()
            }
        }
        
        private var previosState: CurrentPlayerState?
        private var observers: [UUID: AudioPlayerObserver] = [:]
        
        func subscribe(observer: AudioPlayerObserver) -> AudioPlayerStateSubscription {
            let subscriptionID = UUID()
            self.observers[subscriptionID] = observer
            updateStateOfAttachedObserverIfPreviousStateExists(observer)
            let subscription = StateSubscription(onUnsubscribe: { [weak self] in
                self?.observers.removeValue(forKey: subscriptionID)
            })
            return subscription
        }
        
        func receiveNewPlayerState(_ state: CurrentPlayerState) {
            previosState = state
            updateObservers(with: state)
        }
        
        private func updateObservers(with state: CurrentPlayerState) {
            observers.forEach { (key, observer) in
                observer.receive(state)
            }
        }
        
        private func updateStateOfAttachedObserverIfPreviousStateExists(_ observer: AudioPlayerObserver) {
            guard let previosState = previosState else {
                return
            }
            updateObservers(with: previosState)
        }
    }
}

// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import PodcastsModule
import AudioPlayerModule
import AudioPlayerModuleiOS
@testable import Podcats

class LargeAudioPlayerUIIntegrationTests: XCTestCase {
    
    func test_onLoad_doesNotSendsControlSignals() {
        let (sut, _, controlsSpy) = makeSUT()
        sut.loadViewIfNeeded()
        
        XCTAssertTrue(controlsSpy.messages.isEmpty)
    }
    
    func test_sendControlMessages_sendsTogglePlaybackStateToControlsDelegate() {
        let (sut, _, controlsSpy) = makeSUT()
        sut.loadViewIfNeeded()
        
        sut.simulateUserInitiatedTogglePlaybackEpisode()
        
        XCTAssertEqual(controlsSpy.messages, [.tooglePlaybackState])
    }
    
    // MARK: - Helpers
    
    private typealias SUT = (sut: LargeAudioPlayerViewController,
                             statePublisher: AudioPlayerStatePublisher,
                             controlsDelegate: AudioPlayerControlsSpy)
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> SUT {
        let episode = makeEpisode()
        let podcast = makePodcast()
        let controlsSpy = AudioPlayerControlsSpy()
        let statePublisher = AudioPlayerStatePublisher()
        let sut = AudioPlayerUIComposer.largePlayerWith(
            data: (episode, podcast),
            statePublisher: statePublisher,
            controlsDelegate: controlsSpy
        )
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(statePublisher, file: file, line: line)
        trackForMemoryLeaks(controlsSpy, file: file, line: line)
        return (sut, statePublisher, controlsSpy)
    }
    
    private class AudioPlayerControlsSpy: AudioPlayerControlsDelegate {
        enum Message {
            case tooglePlaybackState
        }
        
        private(set) var messages: [Message] = []
        
        func togglePlay() {
            messages.append(.tooglePlaybackState)
        }
        
        func onVolumeChange(value: Float) {}
        
        func onSeek(value: Float) {}
    }
    
    private func makeEpisode() -> Episode {
        Episode(
            id: UUID().uuidString,
            title: "Any Title 1",
            description: "Any Description 1",
            thumbnail: anyURL(),
            audio: anyURL(),
            audioLengthInSeconds: Int.random(in: 1...1000),
            containsExplicitContent: Bool.random(),
            publishDateInMiliseconds: Int.random(in: 1479110301853...1479110401853)
        )
    }
    
    private func makePodcast() -> PodcastDetails {
        PodcastDetails(
            id: UUID().uuidString,
            title: "Any Episode Title",
            publisher: "Any Publisher Title",
            language: "Any language",
            type: .episodic,
            image: anyURL(),
            episodes: [],
            description: "Any description",
            totalEpisodes: 100
        )
    }
}

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
    
    func test_sendControlMessages_sendTogglePlaybackStateToControlsDelegate() {
        let (sut, _, controlsSpy) = makeSUT()
        sut.loadViewIfNeeded()
        
        sut.simulateUserInitiatedTogglePlaybackEpisode()
        
        XCTAssertEqual(controlsSpy.messages, [.tooglePlaybackState])
    }
    
    func test_sendControlMessages_sendVolumeStateToControlsDelegate() {
        let (sut, _, controlsSpy) = makeSUT()
        sut.loadViewIfNeeded()
        
        sut.simulateUserInitiatedVolumeChange(to: 0.5)
        sut.simulateUserInitiatedVolumeChange(to: 0.1)
        
        XCTAssertEqual(controlsSpy.messages, [.volumeChange(0.5), .volumeChange(0.1)])
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
        enum Message: Equatable {
            case tooglePlaybackState
            case volumeChange(Float)
        }
        
        private(set) var messages: [Message] = []
        
        func togglePlay() {
            messages.append(.tooglePlaybackState)
        }
        
        func changeVolumeTo(value: Float) {
            messages.append(.volumeChange(value))
        }
        
        func seekToProgress(_ progress: Float) {}
        
        func seekToSeconds(_ seconds: Int) {}
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

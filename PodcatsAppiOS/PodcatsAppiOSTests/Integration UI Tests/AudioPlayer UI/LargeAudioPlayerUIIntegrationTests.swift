// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import PodcastsModule
import AudioPlayerModule
import AudioPlayerModuleiOS
@testable import Podcats

class LargeAudioPlayerUIIntegrationTests: XCTestCase {
    
    func test_onLoad_doesNotSendsControlSignals() {
        let episode = makeEpisode()
        let podcast = makePodcast()
        
        let controlsSpy = AudioPlayerControlsSpy()
        let statePublisher = AudioPlayerStatePublisher()
        
        _ = AudioPlayerUIComposer.largePlayerWith(
            data: (episode, podcast),
            statePublisher: statePublisher,
            controlsDelegate: controlsSpy
        )
        
        XCTAssertTrue(controlsSpy.messages.isEmpty)
    }
    
    // MARK: - Helpers
    
    private class AudioPlayerControlsSpy: AudioPlayerControlsDelegate {
        enum Message {
            
        }
        
        private(set) var messages: [Message] = []
        
        func togglePlay() {}
        
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

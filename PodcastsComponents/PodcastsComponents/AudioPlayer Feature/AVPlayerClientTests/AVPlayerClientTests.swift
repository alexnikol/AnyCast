// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import AVKit
import AudioPlayerModule
import PodcastsModule

class AVPlayerClient: AudioPlayer {
    
    var delegate: AudioPlayerOutputDelegate?
    private var systemVolume: Float {
        var systemVolume: Float
        #if os(iOS)
            systemVolume = AVAudioSession.sharedInstance().outputVolume
        #elseif os(OSX)
            systemVolume = 0.0
        #endif
        return systemVolume
    }
    
    func play(_ episode: Episode, from podcast: PodcastDetails) {
        delegate?.didUpdateState(with: .startPlayingNewItem(createStartPlayingState(episode: episode, podcast: podcast)))
    }
    
    private func createStartPlayingState(episode: Episode, podcast: PodcastDetails) -> PlayingItem {
        PlayingItem(
            episode: episode,
            podcast: podcast,
            state: .init(
                playbackState: .playing,
                currentTimeInSeconds: 0,
                totalTime: .notDefined,
                progressTimePercentage: 0.0,
                volumeLevel: systemVolume
            )
        )
    }
}

final class AVPlayerClientTests: XCTestCase {
    
    func test_startPlayNewItem_sendsNotificationAboutNewPlayingItem() {
        let episode = makeEpisode()
        let podcast = makePodcast()
        let outputSpy = AudioPlayerOutputSpy()
        let player = AVPlayerClient()
        
        var systemVolume: Float = 0
        #if os(iOS)
            systemVolume = AVAudioSession.sharedInstance().outputVolume
        #endif
        player.delegate = outputSpy
        
        player.play(episode, from: podcast)
        
        let expectedPlayingItem = PlayingItem(
            episode: episode,
            podcast: podcast,
            state: .init(
                playbackState: .playing,
                currentTimeInSeconds: 0,
                totalTime: .notDefined,
                progressTimePercentage: 0.0,
                volumeLevel: systemVolume
            )
        )
        XCTAssertEqual(outputSpy.currentState, .startPlayingNewItem(expectedPlayingItem))
    }
    
    // MARK: - Helper
    
    private class AudioPlayerOutputSpy: AudioPlayerOutputDelegate {
        var currentState: AudioPlayerModule.PlayerState?
        
        func didUpdateState(with state: AudioPlayerModule.PlayerState) {
            self.currentState = state
        }
    }
    
    private func makeEpisode() -> Episode {
        Episode(
            id: UUID().uuidString,
            title: "Any Episode Title",
            description: "Any Episode Description",
            thumbnail: anyURL(),
            audio: anyURL(),
            audioLengthInSeconds: Int.random(in: 1...1000),
            containsExplicitContent: Bool.random(),
            publishDateInMiliseconds: Int.random(in: 1479110301853...1479110401853)
        )
    }
    
    private func makePodcast(title: String = "Any Podcast Title", publisher: String = "Any Publisher Title") -> PodcastDetails {
        PodcastDetails(
            id: UUID().uuidString,
            title: title,
            publisher: publisher,
            language: "Any language",
            type: .episodic,
            image: anyURL(),
            episodes: [],
            description: "Any description",
            totalEpisodes: 100
        )
    }
    
    private func anyURL() -> URL {
        URL(string: "http://a-url.com")!
    }
}

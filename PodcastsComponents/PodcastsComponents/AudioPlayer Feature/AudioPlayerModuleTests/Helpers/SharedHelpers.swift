// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import SharedTestHelpersLibrary
import PodcastsModule
import AudioPlayerModule

extension XCTestCase {
    
    func makeUniqueEpisode(audioLengthInSeconds: Int = 100) -> Episode {
        let publishDateInMiliseconds = Int(1670914583549)
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
    
    func makePodcast(title: String = "Any Podcast Title", publisher: String = "Any Publisher Title") -> PodcastDetails {
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
    
    func makePlayingItem(
        playbackState: PlayingItem.PlaybackState,
        currentTimeInSeconds: Int,
        totalTime: EpisodeDuration,
        playbackSpeed: PlaybackSpeed
    ) -> PlayingItem {
        PlayingItem(
            episode: makeUniqueEpisode(),
            podcast: makePodcast(),
            updates: [
                .playback(playbackState),
                .progress(
                    .init(
                        currentTimeInSeconds: currentTimeInSeconds,
                        totalTime: totalTime,
                        progressTimePercentage: 0.1234
                    )
                ),
                .volumeLevel(0.5),
                .speed(playbackSpeed)
            ]
        )
    }
}

extension Episode: PlayingEpisode {}

extension PodcastDetails: PlayingPodcast {}

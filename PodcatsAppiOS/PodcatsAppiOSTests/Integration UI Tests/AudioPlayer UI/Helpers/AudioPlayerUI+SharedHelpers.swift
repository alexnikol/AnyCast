// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import SharedTestHelpersLibrary
import PodcastsModule
import AudioPlayerModule

func makeEpisode() -> Episode {
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
    title: String = "Any Podcast Title",
    publisher: String = "Any Publisher Title",
    currentTimeInSeconds: Int = 10,
    totalTime: EpisodeDuration = .notDefined,
    playback: PlayingItem.PlaybackState = .playing,
    progressTimePercentage: Float = 0.1,
    volumeLevel: Float = 0.5,
    speedPlayback: PlaybackSpeed = .x0_75
) -> PlayingItem {
    PlayingItem(
        episode: makeEpisode(),
        podcast: makePodcast(title: title, publisher: publisher),
        updates: [
            .playback(playback),
            .progress(
                .init(
                    currentTimeInSeconds: currentTimeInSeconds,
                    totalTime: totalTime,
                    progressTimePercentage: progressTimePercentage
                )
            ),
            .volumeLevel(volumeLevel),
            .speed(speedPlayback)
        ]
    )
}

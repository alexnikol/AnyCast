// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import SharedTestHelpersLibrary
import PodcastsModule
import AudioPlayerModule

func makePlayingEpisode() -> PlayingEpisode {
    PlayingEpisode(
        id: UUID().uuidString,
        title: "Any Episode Title",
        thumbnail: anyURL(),
        audio: anyURL(),
        publishDateInMiliseconds: Int.random(in: 1479110301853...1479110401853)
    )
}

func makePlayingPodcast(title: String = "Any Podcast Title", publisher: String = "Any Publisher Title") -> PlayingPodcast {
    PlayingPodcast(
        id: UUID().uuidString,
        title: title,
        publisher: publisher
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
        episode: makePlayingEpisode(),
        podcast: makePlayingPodcast(title: title, publisher: publisher),
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

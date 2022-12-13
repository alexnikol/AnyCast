// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import SharedTestHelpersLibrary
import AudioPlayerModule
import PodcastsModule

func makeEpisode() -> Episode {
    Episode(
        id: UUID().uuidString,
        title: "Any Episode Title".repeatTimes(10),
        description: "Any Episode Description".repeatTimes(10),
        thumbnail: anyURL(),
        audio: anyURL(),
        audioLengthInSeconds: Int.random(in: 1...1000),
        containsExplicitContent: Bool.random(),
        publishDateInMiliseconds: Int.random(in: 1479110301853...1479110401853)
    )
}

func makePodcast() -> PodcastDetails {
    PodcastDetails(
        id: UUID().uuidString,
        title: "Any Podcast Title",
        publisher: "Any Publisher Title",
        language: "Any language",
        type: .episodic,
        image: anyURL(),
        episodes: [],
        description: "Any description",
        totalEpisodes: 100
    )
}

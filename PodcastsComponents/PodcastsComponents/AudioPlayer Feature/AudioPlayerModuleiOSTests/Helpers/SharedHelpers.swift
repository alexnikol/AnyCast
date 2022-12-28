// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import SharedTestHelpersLibrary
import AudioPlayerModule

func makePlayingEpisode() -> PlayingEpisode {
    PlayingEpisode(
        id: UUID().uuidString,
        title: "Any Episode Title".repeatTimes(10),
        thumbnail: anyURL(),
        audio: anyURL(),
        publishDateInMiliseconds: Int.random(in: 1479110301853...1479110401853)
    )
}

func makePlayingPodcast() -> PlayingPodcast {
    PlayingPodcast(
        id: UUID().uuidString,
        title: "Any Podcast Title",
        publisher: "Any Publisher Title"
    )
}

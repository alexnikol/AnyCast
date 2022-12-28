// Copyright © 2022 Almost Engineer. All rights reserved.

import PodcastsModule
import AudioPlayerModule

extension Episode {
    func toPlayingEpisode() -> PlayingEpisode {
        PlayingEpisode(
            id: id,
            title: title,
            thumbnail: thumbnail,
            audio: audio,
            publishDateInMiliseconds: publishDateInMiliseconds
        )
    }
}

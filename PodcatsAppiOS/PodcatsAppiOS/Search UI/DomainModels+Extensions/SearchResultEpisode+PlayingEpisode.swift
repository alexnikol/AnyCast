// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import SearchContentModule
import AudioPlayerModule

extension SearchResultEpisode {
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

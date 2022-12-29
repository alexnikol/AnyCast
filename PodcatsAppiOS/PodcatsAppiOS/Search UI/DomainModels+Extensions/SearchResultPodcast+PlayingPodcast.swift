// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import SearchContentModule
import AudioPlayerModule

extension SearchResultPodcast {
    func toPlayingPodcast() -> PlayingPodcast {
        PlayingPodcast(id: id, title: titleOriginal, publisher: publisherOriginal)
    }
}

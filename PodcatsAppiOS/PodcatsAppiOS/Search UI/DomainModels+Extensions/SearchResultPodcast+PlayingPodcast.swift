// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import SearchContentModule
import AudioPlayerModule

extension SearchResultPodcast: PlayingPodcast {
    public var title: String {
        titleOriginal
    }
    
    public var publisher: String {
        publisherOriginal
    }
}

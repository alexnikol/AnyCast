// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import PodcastsModule

public struct GeneralSearchContentResultViewModel {
    public let episodes: [Episode]
    public let podcasts: [SearchResultPodcast]
    public let curatedLists: [SearchResultCuratedList]
    
    public init(episodes: [Episode], podcasts: [SearchResultPodcast], curatedLists: [SearchResultCuratedList]) {
        self.episodes = episodes
        self.podcasts = podcasts
        self.curatedLists = curatedLists
    }
}

// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public struct GeneralSearchContentResultViewModel {
    public let episodes: [SearchResultEpisode]
    public let podcasts: [SearchResultPodcast]
    public let curatedLists: [SearchResultCuratedList]
    
    public init(episodes: [SearchResultEpisode], podcasts: [SearchResultPodcast], curatedLists: [SearchResultCuratedList]) {
        self.episodes = episodes
        self.podcasts = podcasts
        self.curatedLists = curatedLists
    }
}

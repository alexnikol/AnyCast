// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public enum GeneralSearchContentResultItem: Equatable {
    case episode(SearchResultEpisode)
    case podcast(SearchResultPodcast)
    case curatedList(SearchResultCuratedList)
}

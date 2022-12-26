// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import PodcastsModule

public enum GeneralSearchContentResultItem: Equatable {
    case episode(Episode)
    case podcast(SearchResultPodcast)
    case curatedList(SearchResultCuratedList)
}

// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import PodcastsGenresList

public struct TypeaheadSearchContentResultViewModel {
    public let terms: [String]
    public let genres: [Genre]
    public let podcasts: [SearchResultPodcast]
}

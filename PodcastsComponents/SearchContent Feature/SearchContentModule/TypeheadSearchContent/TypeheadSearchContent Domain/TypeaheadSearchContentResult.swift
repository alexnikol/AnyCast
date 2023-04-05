// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import PodcastsGenresList

public struct TypeaheadSearchContentResult: Equatable {
    public let terms: [String]
    public let genres: [Genre]
    public let podcasts: [SearchResultPodcast]
    
    public init(terms: [String], genres: [Genre], podcasts: [SearchResultPodcast]) {
        self.terms = terms
        self.genres = genres
        self.podcasts = podcasts
    }
}

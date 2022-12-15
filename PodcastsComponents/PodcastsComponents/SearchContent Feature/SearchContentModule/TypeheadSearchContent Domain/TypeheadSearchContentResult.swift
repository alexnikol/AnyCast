// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import PodcastsGenresList

public struct TypeheadSearchContentResult: Equatable {
    public let terms: [String]
    public let genres: [Genre]
    public let podcasts: [PodcastSearchResult]
    
    public init(terms: [String], genres: [Genre], podcasts: [PodcastSearchResult]) {
        self.terms = terms
        self.genres = genres
        self.podcasts = podcasts
    }
}

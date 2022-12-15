// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import PodcastsGenresList

public final class TypeheadSearchContentPresenter {
    private init() {}
    
    public static func map(_ genres: [Genre]) -> [SearchGenreViewModel] {
        return genres.map { $0.name }
    }
    
    public static func map(_ terms: [String]) -> [SearchTermViewModel] {
        return terms
    }
    
    public static func map(_ podcasts: [PodcastSearchResult]) -> [PodcastSearchResultViewModel] {
        return podcasts.map {
            PodcastSearchResultViewModel(
                titleOriginal: $0.titleOriginal,
                publisherOriginal: $0.publisherOriginal,
                thumbnail: $0.thumbnail
            )
        }
    }
}

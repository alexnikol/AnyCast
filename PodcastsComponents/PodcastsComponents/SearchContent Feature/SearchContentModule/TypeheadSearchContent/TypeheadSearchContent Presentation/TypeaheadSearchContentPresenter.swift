// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import PodcastsGenresList

public final class TypeaheadSearchContentPresenter {
    private init() {}
    
    public static func map(_ model: TypeaheadSearchContentResult) -> TypeaheadSearchContentResultViewModel {
        TypeaheadSearchContentResultViewModel(
            terms: model.terms,
            genres: model.genres,
            podcasts: model.podcasts
        )
    }
    
    public static func map(_ genre: Genre) -> TypeaheadSearchGenreViewModel {
        genre.name
    }
    
    public static func map(_ term: String) -> TypeaheadSearchTermViewModel {
        return term
    }
    
    public static func map(_ podcast: SearchResultPodcast) -> TypeaheadSearchResultPodcastViewModel {
        TypeaheadSearchResultPodcastViewModel(
            titleOriginal: podcast.titleOriginal,
            publisherOriginal: podcast.publisherOriginal,
            thumbnail: podcast.thumbnail
        )
    }
}

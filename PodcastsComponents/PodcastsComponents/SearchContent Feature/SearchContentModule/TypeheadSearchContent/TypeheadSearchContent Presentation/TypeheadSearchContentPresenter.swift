// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import PodcastsGenresList

public final class TypeheadSearchContentPresenter {
    private init() {}
    
    public static func map(_ model: TypeheadSearchContentResult) -> TypeheadSearchContentResultViewModel {
        TypeheadSearchContentResultViewModel(
            terms: model.terms,
            genres: model.genres,
            podcasts: model.podcasts
        )
    }
    
    public static func map(_ genre: Genre) -> TypeheadSearchGenreViewModel {
        genre.name
    }
    
    public static func map(_ term: String) -> TypeheadSearchTermViewModel {
        return term
    }
    
    public static func map(_ podcast: SearchResultPodcast) -> TypeheadSearchResultPodcastViewModel {
        TypeheadSearchResultPodcastViewModel(
            titleOriginal: podcast.titleOriginal,
            publisherOriginal: podcast.publisherOriginal,
            thumbnail: podcast.thumbnail
        )
    }
}

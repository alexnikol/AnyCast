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
    
    public static func map(_ genres: [Genre]) -> [TypeheadSearchGenreViewModel] {
        return genres.map { $0.name }
    }
    
    public static func map(_ terms: [String]) -> [TypeheadSearchTermViewModel] {
        return terms
    }
    
    public static func map(_ podcasts: [SearchResultPodcast]) -> [TypeheadSearchResultPodcastViewModel] {
        return podcasts.map {
            TypeheadSearchResultPodcastViewModel(
                titleOriginal: $0.titleOriginal,
                publisherOriginal: $0.publisherOriginal,
                thumbnail: $0.thumbnail
            )
        }
    }
}

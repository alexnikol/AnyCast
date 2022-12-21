// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import PodcastsModule

public final class GeneralSearchContentPresenter {
    private init() {}
    
    public static func map(_ model: GeneralSearchContentResult) -> GeneralSearchContentResultViewModel {
        var episodes: [Episode] = []
        var podcasts: [SearchResultPodcast] = []
        var curatedLists: [SearchResultCuratedList] = []
        
        model.result.forEach { model in
            switch model {
            case let .episode(episode):
                episodes.append(episode)
                
            case let .podcast(podcast):
                podcasts.append(podcast)
                
            case let .curatedList(curatedList):
                curatedLists.append(curatedList)
            }
        }
        
        return GeneralSearchContentResultViewModel(
            episodes: episodes,
            podcasts: podcasts,
            curatedLists: curatedLists
        )
    }
    
    public static func map(_ model: Episode, calendar: Calendar = .current, locale: Locale = .current) -> EpisodeViewModel {
        return EpisodesPresenter(calendar: calendar, locale: locale).map(model)
    }
    
    public static func map(_ model: SearchResultPodcast) -> SearchResultPodcastViewModel {
        SearchResultPodcastViewModel(
            title: model.titleOriginal,
            publisher: model.publisherOriginal,
            thumbnail: model.thumbnail
        )
    }
    
    public static func map(_ model: SearchResultCuratedList) -> SearchResultCuratedListViewModel {
        SearchResultCuratedListViewModel(
            title: model.titleOriginal,
            description: model.descriptionOriginal,
            podcasts: model.podcasts
        )
    }
}

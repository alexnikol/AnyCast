// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public final class GeneralSearchContentPresenter {
    private let calendar: Calendar
    private let locale: Locale
    
    public init(calendar: Calendar = .current, locale: Locale = .current) {
        self.calendar = calendar
        self.locale = locale
    }
    
    private lazy var relativeDateTimeFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.calendar = calendar
        formatter.locale = locale
        return formatter
    }()
    
    private lazy var dateFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .brief
        var newCalendar = calendar
        newCalendar.locale = locale
        formatter.calendar = newCalendar
        return formatter
    }()
    
    public func map(_ model: GeneralSearchContentResult) -> GeneralSearchContentResultViewModel {
        var episodes: [SearchResultEpisode] = []
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
        
    public func map(_ model: SearchResultPodcast) -> SearchResultPodcastViewModel {
        SearchResultPodcastViewModel(
            title: model.titleOriginal,
            publisher: model.publisherOriginal,
            thumbnail: model.thumbnail
        )
    }
    
    public func map(_ model: SearchResultCuratedList) -> SearchResultCuratedListViewModel {
        SearchResultCuratedListViewModel(
            title: model.titleOriginal,
            description: model.descriptionOriginal,
            podcasts: model.podcasts
        )
    }
    
    public func map(_ model: SearchResultEpisode, currentDate: Date = Date()) -> SearchResultEpisodeViewModel {
        let presentablePublishDate = mapToPresentablePublishDate(
            publishDateInMiliseconds: model.publishDateInMiliseconds,
            relativeTo: currentDate
        )
        return SearchResultEpisodeViewModel(
            title: model.title,
            description: model.description,
            thumbnail: model.thumbnail,
            audio: model.audio,
            displayAudioLengthInSeconds: mapToPresentableAudioLength(model.audioLengthInSeconds),
            displayPublishDate: presentablePublishDate
        )
    }
        
    private func mapToPresentableAudioLength(_ lengthInSeconds: Int) -> String {
        dateFormatter.string(from: TimeInterval(lengthInSeconds)) ?? "INVALID_DURATION"
    }
    
    private func mapToPresentablePublishDate(publishDateInMiliseconds: Int, relativeTo currentDate: Date) -> String {
        let publishDateInSeconds = publishDateInMiliseconds / 1000
        let presentablePublishDate = Date(timeIntervalSince1970: TimeInterval(publishDateInSeconds))
        return relativeDateTimeFormatter.localizedString(for: presentablePublishDate, relativeTo: currentDate)
    }
}

public extension GeneralSearchContentPresenter {
    
    static var episodesTitle: String {
        return NSLocalizedString(
            "GENERAL_SEARCH_SECTION_EPISODES",
            tableName: "GeneralSearch",
            bundle: .init(for: Self.self),
            comment: "Title for the found episodes section view"
        )
    }
    
    static var podcastsTitle: String {
        return NSLocalizedString(
            "GENERAL_SEARCH_SECTION_PODCASTS",
            tableName: "GeneralSearch",
            bundle: .init(for: Self.self),
            comment: "Title for the found podcasts section view"
        )
    }
}

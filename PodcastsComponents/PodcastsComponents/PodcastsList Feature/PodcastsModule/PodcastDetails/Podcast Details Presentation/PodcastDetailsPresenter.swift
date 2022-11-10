// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public final class PodcastDetailsPresenter {
    
    public static func map(_ model: PodcastDetails) -> PodcastDetailsViewModel {
        .init(
            title: model.title,
            publisher: model.publisher,
            language: model.language,
            type: String(describing: model.type),
            image: model.image,
            episodes: model.episodes,
            description: model.description,
            totalEpisodes: String(model.totalEpisodes)
        )
    }
    
    private static var relativeDateTimeFormatter: RelativeDateTimeFormatter = {
        RelativeDateTimeFormatter()
    }()
    
    private static var dateFormatter: DateComponentsFormatter = {
        let dateFormatter = DateComponentsFormatter()
        dateFormatter.allowedUnits = [.hour, .minute, .second]
        dateFormatter.unitsStyle = .brief
        return dateFormatter
    }()
    
    public static func map(
        _ model: Episode,
        currentDate: Date = Date(),
        calendar: Calendar = .current,
        locale: Locale = .current
    ) -> EpisodeViewModel {
        
        let presentablePublishDate = mapToPresentablePublishDate(
            publishDateInMiliseconds: model.publishDateInMiliseconds,
            currentDate,
            calendar,
            locale
        )
        return EpisodeViewModel(
            title: model.title,
            description: model.description,
            thumbnail: model.thumbnail,
            audio: model.audio,
            displayAudioLengthInSeconds: mapToPresentableAudioLength(model.audioLengthInSeconds, calendar: calendar),
            displayPublishDate: presentablePublishDate
        )
    }
    
    private static func mapToPresentableAudioLength(_ lengthInSeconds: Int, calendar: Calendar) -> String {
        dateFormatter.calendar = calendar
        let presentableAudioLength = dateFormatter.string(from: TimeInterval(lengthInSeconds)) ?? "INVALID_DURATION"
        return presentableAudioLength
    }
    
    private static func mapToPresentablePublishDate(
        publishDateInMiliseconds: Int,
        _ currentDate: Date,
        _ calendar: Calendar,
        _ locale: Locale
    ) -> String {
        relativeDateTimeFormatter.calendar = calendar
        relativeDateTimeFormatter.locale = locale
        let publishDateInSeconds = publishDateInMiliseconds / 1000
        let presentablePublishDate = Date(timeIntervalSince1970: TimeInterval(publishDateInSeconds))
        return relativeDateTimeFormatter.localizedString(for: presentablePublishDate, relativeTo: currentDate)
    }
}

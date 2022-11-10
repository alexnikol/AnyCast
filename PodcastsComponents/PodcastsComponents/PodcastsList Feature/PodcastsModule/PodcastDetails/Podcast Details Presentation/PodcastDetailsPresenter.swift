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
    
    public static func map(
        _ model: Episode,
        currentDate: Date = Date(),
        calendar: Calendar = .current,
        locale: Locale = .current
    ) -> EpisodeViewModel {
        let relativeDateTimeFormatter = RelativeDateTimeFormatter()
        relativeDateTimeFormatter.calendar = calendar
        relativeDateTimeFormatter.locale = locale
        let publishDateInSeconds = model.publishDateInMiliseconds / 1000
        let publishDate = Date(timeIntervalSince1970: TimeInterval(publishDateInSeconds))

        let dateFormatter = DateComponentsFormatter()
        dateFormatter.allowedUnits = [.hour, .minute, .second]
        dateFormatter.calendar = calendar
        dateFormatter.unitsStyle = .brief
        let result = dateFormatter.string(from: TimeInterval(model.audioLengthInSeconds)) ?? "INVALID_DURATION"
        
        return EpisodeViewModel(
            title: model.title,
            description: model.description,
            thumbnail: model.thumbnail,
            audio: model.audio,
            displayAudioLengthInSeconds: result,
            displayPublishDate: relativeDateTimeFormatter.localizedString(for: publishDate, relativeTo: currentDate)
        )
    }
}

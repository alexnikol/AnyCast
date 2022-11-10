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
        let formatter = RelativeDateTimeFormatter()
        formatter.calendar = calendar
        formatter.locale = locale
        let publishDateInSeconds = model.publishDateInMiliseconds / 1000
        let publishDate = Date(timeIntervalSince1970: TimeInterval(publishDateInSeconds))
        
        return EpisodeViewModel(
            title: model.title,
            description: model.description,
            thumbnail: model.thumbnail,
            audio: model.audio,
            displayAudioLengthInSeconds: String(model.audioLengthInSeconds),
            displayPublishDate: formatter.localizedString(for: publishDate, relativeTo: currentDate)
        )
    }
}

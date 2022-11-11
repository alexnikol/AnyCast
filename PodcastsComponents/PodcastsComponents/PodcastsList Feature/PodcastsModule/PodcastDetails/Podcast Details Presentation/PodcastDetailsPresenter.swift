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
}

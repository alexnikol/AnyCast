// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public enum PodcastDetailsPresenter {
    
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
}

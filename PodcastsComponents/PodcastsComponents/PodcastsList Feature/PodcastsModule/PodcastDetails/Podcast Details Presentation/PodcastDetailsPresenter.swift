// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public final class PodcastDetailsPresenter {
    
    public static func map(_ model: PodcastDetails) -> PodcastDetailsViewModel {
        .init(
            title: model.title,
            publisher: model.publisher,
            language: model.language,
            type: "",
            image: model.image,
            episodes: model.episodes,
            description: model.description,
            totalEpisodes: String(model.totalEpisodes)
        )
    }
    
    public static func map(_ model: Episode) -> EpisodeViewModel {
        .init(
            title: model.title,
            description: model.description,
            thumbnail: model.thumbnail,
            audio: model.audio,
            displayAudioLengthInSeconds: String(model.audioLengthInSeconds)
        )
    }
}

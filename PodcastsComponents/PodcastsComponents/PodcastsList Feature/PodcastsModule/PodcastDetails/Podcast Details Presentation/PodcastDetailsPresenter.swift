// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public struct PodcastDetailsViewModel {
    public let title: String
    public let publisher: String
    public let language: String
    public let type: String
    public let image: URL
    public let episodes: [Episode]
    public let description: String
    public let totalEpisodes: String
}

public struct EpisodeViewModel {
    public let title: String
    public let description: String
    public let thumbnail: URL
    public let audio: URL
    public let displayAudioLengthInSeconds: String
}

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

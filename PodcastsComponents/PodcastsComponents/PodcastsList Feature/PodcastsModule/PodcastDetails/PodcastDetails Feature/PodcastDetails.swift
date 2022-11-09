// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public struct PodcastDetails: PodcastFullInfo, Equatable {
    public let id: String
    public let title: String
    public let publisher: String
    public let language: String
    public let type: PodcastType
    public let image: URL
    public let episodes: [Episode]
    public let description: String
    public let totalEpisodes: Int
    
    public init(id: String,
                title: String,
                publisher: String,
                language: String,
                type: PodcastType,
                image: URL,
                episodes: [Episode], description: String, totalEpisodes: Int) {
        self.id = id
        self.title = title
        self.publisher = publisher
        self.language = language
        self.type = type
        self.image = image
        self.episodes = episodes
        self.description = description
        self.totalEpisodes = totalEpisodes
    }
}

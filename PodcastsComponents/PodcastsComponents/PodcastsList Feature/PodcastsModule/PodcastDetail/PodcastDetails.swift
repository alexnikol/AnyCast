// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public struct PodcastDetails: PodcastFullInfo {
    public var id: String
    public var title: String
    public var publisher: String
    public var language: String
    public var type: PodcastType
    public var image: URL
    public var episodes: [Episode]
    public var description: String
    public var totalEpisodes: Int
    
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

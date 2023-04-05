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
    
    public init(title: String, publisher: String, language: String, type: String, image: URL, episodes: [Episode], description: String, totalEpisodes: String) {
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

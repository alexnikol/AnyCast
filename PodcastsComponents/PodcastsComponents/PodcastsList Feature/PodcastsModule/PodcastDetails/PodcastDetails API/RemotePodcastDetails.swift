// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

struct RemotePodcastDetails: Decodable {
    let id: String
    let title: String
    let publisher: String
    let language: String
    let type: RemotePodcastType
    let image: URL
    let episodes: [RemoteEpisode]
    let description: String
    let totalEpisodes: Int
    
    private enum CodingKeys: String, CodingKey {
        case id, title, publisher, language, type, image, episodes, description
        case totalEpisodes = "total_episodes"
    }
}

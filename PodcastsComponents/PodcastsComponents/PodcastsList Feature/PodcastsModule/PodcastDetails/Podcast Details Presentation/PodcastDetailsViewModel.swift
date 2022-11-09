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

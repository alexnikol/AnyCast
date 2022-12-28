// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public struct PlayingItem: Equatable {
    public let podcast: PlayingPodcast
    public let episode: PlayingEpisode
    public let updates: [State]
    
    public init(episode: PlayingEpisode, podcast: PlayingPodcast, updates: [State]) {
        self.episode = episode
        self.podcast = podcast
        self.updates = updates
    }
    
    public static func == (lhs: PlayingItem, rhs: PlayingItem) -> Bool {
        return lhs.episode.id == rhs.episode.id && lhs.updates == rhs.updates
    }
}

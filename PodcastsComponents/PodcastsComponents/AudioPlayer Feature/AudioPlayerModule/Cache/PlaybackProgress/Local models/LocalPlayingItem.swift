// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public struct LocalPlayingItem: Equatable {
    public let podcast: LocalPlayingPodcast
    public let episode: LocalPlayingEpisode
    public let updates: [State]
    
    public init(episode: LocalPlayingEpisode, podcast: LocalPlayingPodcast, updates: [State]) {
        self.episode = episode
        self.podcast = podcast
        self.updates = updates
    }
    
    public static func == (lhs: LocalPlayingItem, rhs: LocalPlayingItem) -> Bool {
        return lhs.episode.id == rhs.episode.id && lhs.updates == rhs.updates
    }
}

// MARK: - LocalPlayingItem mapping helper

extension LocalPlayingItem {
    func toModel() -> PlayingItem {
        PlayingItem(
            episode: TemporaryPlayingEpisode(
                id: episode.id,
                title: episode.title,
                thumbnail: episode.thumbnail,
                audio: episode.audio,
                publishDateInMiliseconds: episode.publishDateInMiliseconds
            ),
            podcast: TemporaryPlayingPodcast(
                id: podcast.id,
                title: podcast.title,
                publisher: podcast.publisher),
            updates: updates.map( { $0.toModel() })
        )
    }
}

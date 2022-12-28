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

public extension LocalPlayingItem {
    enum PlaybackState: Equatable {
        case playing
        case pause
        case loading
    }
}

public extension LocalPlayingItem {
    struct Progress: Equatable {
        public let currentTimeInSeconds: Int
        public let totalTime: LocalEpisodeDuration
        public let progressTimePercentage: Float
        
        public init(currentTimeInSeconds: Int, totalTime: LocalEpisodeDuration, progressTimePercentage: Float) {
            self.currentTimeInSeconds = currentTimeInSeconds
            self.totalTime = totalTime
            self.progressTimePercentage = progressTimePercentage
        }
    }
}

public extension LocalPlayingItem {
    enum State: Equatable {
        case playback(PlaybackState)
        case volumeLevel(Float)
        case progress(Progress)
        case speed(PlaybackSpeed)
    }
}

public enum LocalEpisodeDuration: Equatable {
    case notDefined
    case valueInSeconds(Int)
}

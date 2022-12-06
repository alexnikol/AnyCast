// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import PodcastsModule

public struct PlayingItem: Equatable {
    public let podcast: PodcastDetails
    public let episode: Episode
    public let updates: [State]
    
    public init(episode: Episode, podcast: PodcastDetails, updates: [State]) {
        self.episode = episode
        self.podcast = podcast
        self.updates = updates
    }
}

public extension PlayingItem {
    enum PlaybackState: Equatable {
        case playing
        case pause
        case loading
    }
}

public extension PlayingItem {
    struct Progress: Equatable {
        public let currentTimeInSeconds: Int
        public let totalTime: EpisodeDuration
        public let progressTimePercentage: Float
        
        public init(currentTimeInSeconds: Int, totalTime: EpisodeDuration, progressTimePercentage: Float) {
            self.currentTimeInSeconds = currentTimeInSeconds
            self.totalTime = totalTime
            self.progressTimePercentage = progressTimePercentage
        }
    }
}

public extension PlayingItem {
    
    enum State: Equatable {
        case playback(PlaybackState)
        case volumeLevel(Float)
        case progress(Progress)
        case speed(PlaybackSpeed)
    }
}

public enum EpisodeDuration: Equatable {
    case notDefined
    case valueInSeconds(Int)
}

// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import PodcastsModule

public struct PlayingItem: Equatable {
    public let episode: Episode
    public let state: State
    
    public init(episode: Episode, state: PlayingItem.State) {
        self.episode = episode
        self.state = state
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
    struct State: Equatable {
        let playbackState: PlaybackState
        let currentTimeInSeconds: Int
        let totalTime: EpisodeDuration
        let progressTimePercentage: Double
        let volumeLevel: Double
        
        public init(
            playbackState: PlayingItem.PlaybackState,
            currentTimeInSeconds: Int,
            totalTime: EpisodeDuration,
            progressTimePercentage: Double,
            volumeLevel: Double
        ) {
            self.playbackState = playbackState
            self.currentTimeInSeconds = currentTimeInSeconds
            self.totalTime = totalTime
            self.progressTimePercentage = progressTimePercentage
            self.volumeLevel = volumeLevel
        }
    }
}

public enum EpisodeDuration: Equatable {
    case notDefined
    case valueInSeconds(Int)
}

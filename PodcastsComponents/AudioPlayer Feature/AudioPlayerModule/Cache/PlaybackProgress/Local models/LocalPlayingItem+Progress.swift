// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

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

// MARK: - LocalPlayingItem.Progress mapping helper

extension LocalPlayingItem.Progress {
    func toModel() -> PlayingItem.Progress {
        .init(
            currentTimeInSeconds: currentTimeInSeconds,
            totalTime: totalTime.toModel(),
            progressTimePercentage: progressTimePercentage
        )
    }
}

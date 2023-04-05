// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

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

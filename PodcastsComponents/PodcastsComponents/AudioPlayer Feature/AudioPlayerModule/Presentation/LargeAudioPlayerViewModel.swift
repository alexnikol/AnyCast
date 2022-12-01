// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public struct LargeAudioPlayerViewModel {
    public let titleLabel: String
    public let descriptionLabel: String
    public let currentTimeLabel: String
    public let endTimeLabel: String
    public let progressTimePercentage: Float
    public let volumeLevel: Float
    public let playbackState: PlaybackStateViewModel
    
    public init(
        titleLabel: String,
        descriptionLabel: String,
        currentTimeLabel: String,
        endTimeLabel: String,
        progressTimePercentage: Float,
        volumeLevel: Float,
        playbackState: PlaybackStateViewModel
    ) {
        self.titleLabel = titleLabel
        self.descriptionLabel = descriptionLabel
        self.currentTimeLabel = currentTimeLabel
        self.endTimeLabel = endTimeLabel
        self.progressTimePercentage = progressTimePercentage
        self.volumeLevel = volumeLevel
        self.playbackState = playbackState
    }
}

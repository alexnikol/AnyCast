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
}

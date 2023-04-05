// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public struct StickyAudioPlayerViewModel {
    public let titleLabel: String
    public let descriptionLabel: String
    public let thumbnailURL: URL
    public let playbackViewModel: PlaybackStateViewModel
    
    public init(
        titleLabel: String,
        descriptionLabel: String,
        thumbnailURL: URL,
        playbackViewModel: PlaybackStateViewModel
    ) {
        self.titleLabel = titleLabel
        self.descriptionLabel = descriptionLabel
        self.thumbnailURL = thumbnailURL
        self.playbackViewModel = playbackViewModel
    }
}

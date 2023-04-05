// Copyright © 2023 Almost Engineer. All rights reserved.

import Foundation

public struct CurrentEpisodeWidgetViewModel {
    public let episodeTitle: String
    public let podcastTitle: String
    public let timeLabel: String
    public let thumbnailData: Data?
    
    public init(episodeTitle: String, podcastTitle: String, timeLabel: String, thumbnailData: Data? = nil) {
        self.episodeTitle = episodeTitle
        self.podcastTitle = podcastTitle
        self.timeLabel = timeLabel
        self.thumbnailData = thumbnailData
    }
}

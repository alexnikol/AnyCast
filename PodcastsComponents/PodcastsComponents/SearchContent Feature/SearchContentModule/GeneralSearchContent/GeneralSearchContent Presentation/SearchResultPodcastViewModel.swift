// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public struct SearchResultPodcastViewModel {
    public let title: String
    public let publisher: String
    public let thumbnail: URL
    
    public init(title: String, publisher: String, thumbnail: URL) {
        self.title = title
        self.publisher = publisher
        self.thumbnail = thumbnail
    }
}

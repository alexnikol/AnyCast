// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public struct PodcastSearchResult: Equatable {
    public let id: String
    public let titleOriginal: String
    public let publisherOriginal: String
    public let image: URL
    public let thumbnail: URL
    
    public init(id: String, titleOriginal: String, publisherOriginal: String, image: URL, thumbnail: URL) {
        self.id = id
        self.titleOriginal = titleOriginal
        self.publisherOriginal = publisherOriginal
        self.image = image
        self.thumbnail = thumbnail
    }
}

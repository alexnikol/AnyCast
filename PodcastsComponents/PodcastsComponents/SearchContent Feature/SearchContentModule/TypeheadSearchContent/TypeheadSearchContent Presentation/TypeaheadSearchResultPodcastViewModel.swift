// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public struct TypeaheadSearchResultPodcastViewModel {
    public let titleOriginal: String
    public let publisherOriginal: String
    public let thumbnail: URL
    
    public init(titleOriginal: String, publisherOriginal: String, thumbnail: URL) {
        self.titleOriginal = titleOriginal
        self.publisherOriginal = publisherOriginal
        self.thumbnail = thumbnail
    }
}

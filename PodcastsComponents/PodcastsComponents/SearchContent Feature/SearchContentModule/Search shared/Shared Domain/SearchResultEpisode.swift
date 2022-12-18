// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public struct SearchResultEpisode: Equatable {
    public let id: String
    public let titleOriginal: String
    public let descriptionOriginal: String
    public let image: URL
    public let thumbnail: URL
    
    public init(id: String, titleOriginal: String, descriptionOriginal: String, image: URL, thumbnail: URL) {
        self.id = id
        self.titleOriginal = titleOriginal
        self.descriptionOriginal = descriptionOriginal
        self.image = image
        self.thumbnail = thumbnail
    }
}

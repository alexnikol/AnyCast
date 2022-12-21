// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public struct SearchResultEpisodeViewModel {
    public let title: String
    public let description: String
    public let thumbnail: URL
    
    public init(title: String, description: String, thumbnail: URL) {
        self.title = title
        self.description = description
        self.thumbnail = thumbnail
    }
}

// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public enum PodcastType {
    case serial
    case episodic
}

public struct Podcast: Equatable {
    public let id: String
    public let title: String
    public let publisher: String
    public let language: String
    public let type: PodcastType
    public let image: URL
    
    public init(id: String, title: String, publisher: String, language: String, type: PodcastType, image: URL) {
        self.id = id
        self.title = title
        self.publisher = publisher
        self.language = language
        self.type = type
        self.image = image
    }
}

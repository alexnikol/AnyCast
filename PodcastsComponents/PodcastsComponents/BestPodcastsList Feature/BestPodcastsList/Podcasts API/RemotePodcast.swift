// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

enum RemotePodcastType: String, Decodable {
    case serial
    case episodic
}

struct RemotePodcast: Decodable {
    let id: String
    let title: String
    let publisher: String
    let language: String
    let type: RemotePodcastType
    let image: URL
    
    init(id: String, title: String, publisher: String, language: String, type: RemotePodcastType, image: URL) {
        self.id = id
        self.title = title
        self.publisher = publisher
        self.language = language
        self.type = type
        self.image = image
    }
}

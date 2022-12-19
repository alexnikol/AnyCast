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
}

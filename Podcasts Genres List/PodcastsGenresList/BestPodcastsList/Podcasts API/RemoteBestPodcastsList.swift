// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

struct RemoteBestPodcastsList: Decodable {
    let genreId: Int
    let genreName: String
    let podcasts: [RemotePodcast]
    
    private enum CodingKeys: String, CodingKey {
        case genreId = "id"
        case genreName = "name"
        case podcasts
    }
}

// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

struct RemoteSearchResultPodcast: Decodable {
    let id: String
    let image: URL
    let thumbnail: URL
    let titleOriginal: String
    let publisherOriginal: String
    
    private enum CodingKeys: String, CodingKey {
        case id, image, thumbnail
        case titleOriginal = "title_original"
        case publisherOriginal = "publisher_original"
    }
}

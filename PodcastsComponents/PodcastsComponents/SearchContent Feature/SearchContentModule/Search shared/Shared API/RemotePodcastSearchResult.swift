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

extension RemoteSearchResultPodcast {
    func toDomainModel() -> SearchResultPodcast {
        SearchResultPodcast(
            id: self.id,
            titleOriginal: self.titleOriginal,
            publisherOriginal: self.publisherOriginal,
            image: self.image,
            thumbnail: self.thumbnail
        )
    }
}

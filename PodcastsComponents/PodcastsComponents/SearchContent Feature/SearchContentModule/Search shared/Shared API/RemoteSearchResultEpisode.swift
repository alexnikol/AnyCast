// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

struct RemoteSearchResultEpisode: Decodable {
    let id: String
    let image: URL
    let thumbnail: URL
    let titleOriginal: String
    let descriptionOriginal: String
    
    private enum CodingKeys: String, CodingKey {
        case id, image, thumbnail
        case titleOriginal = "title_original"
        case descriptionOriginal = "description_original"
    }
}

extension RemoteSearchResultEpisode {
    func toDomainModel() -> SearchResultEpisode {
        SearchResultEpisode(
            id: self.id,
            titleOriginal: self.titleOriginal,
            descriptionOriginal: self.descriptionOriginal,
            image: self.image,
            thumbnail: self.thumbnail
        )
    }
}

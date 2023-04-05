// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

struct RemoteSearchResultCuratedList: Decodable {
    let id: String
    let titleOriginal: String
    let descriptionOriginal: String
    let podcasts: [RemoteSearchResultPodcast]
    
    private enum CodingKeys: String, CodingKey {
        case id, podcasts
        case titleOriginal = "title_original"
        case descriptionOriginal = "description_original"
    }
}

extension RemoteSearchResultCuratedList {
    func toDomainModel() -> SearchResultCuratedList {
        SearchResultCuratedList(
            id: id,
            titleOriginal: titleOriginal,
            descriptionOriginal: descriptionOriginal,
            podcasts: podcasts.map { $0.toDomainModel() }
        )
    }
}

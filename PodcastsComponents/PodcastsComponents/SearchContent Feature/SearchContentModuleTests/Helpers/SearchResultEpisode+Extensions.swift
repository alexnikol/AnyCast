// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import SearchContentModule

extension Array where Element == SearchResultEpisode {
    func toJson() -> [[String: Any]] {
        let podcast = uniquePodcastSearchResults().toJson()[0]
        return map { episode in
            let json = [
                "id": episode.id,
                "image": episode.image.absoluteString,
                "thumbnail": episode.thumbnail.absoluteString,
                "title_original": episode.titleOriginal,
                "description_original": episode.descriptionOriginal,
                "podcast": podcast
            ] as [String: Any]
            
            return json
        }
    }
}

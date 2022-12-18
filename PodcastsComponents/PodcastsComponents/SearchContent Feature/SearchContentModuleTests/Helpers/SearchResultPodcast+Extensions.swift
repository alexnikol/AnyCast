// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import SearchContentModule

extension Array where Element == SearchResultPodcast {
    func toJson() -> [[String: Any]] {
        map { podcast in
            let json = [
                "id": podcast.id,
                "image": podcast.image.absoluteString,
                "thumbnail": podcast.thumbnail.absoluteString,
                "title_original": podcast.titleOriginal,
                "publisher_original": podcast.publisherOriginal
            ] as [String: Any]
            
            return json
        }
    }
}

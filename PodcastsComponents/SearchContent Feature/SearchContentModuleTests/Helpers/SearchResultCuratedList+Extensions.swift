// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import SearchContentModule

extension Array where Element == SearchResultCuratedList {
    func toJson() -> [[String: Any]] {
        map { list in
            let json = [
                "id": list.id,
                "title_original": list.titleOriginal,
                "description_original": list.descriptionOriginal,
                "podcasts": list.podcasts.toJson()
            ] as [String: Any]
            
            return json
        }
    }
}

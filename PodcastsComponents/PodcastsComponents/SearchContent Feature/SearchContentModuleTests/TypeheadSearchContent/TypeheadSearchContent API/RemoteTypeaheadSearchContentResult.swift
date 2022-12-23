// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

class RemoteTypeaheadSearchContentResult: Decodable {
    let terms: [String]
    let genres: [RemoteGenre]
    let podcasts: [RemoteSearchResultPodcast]
}

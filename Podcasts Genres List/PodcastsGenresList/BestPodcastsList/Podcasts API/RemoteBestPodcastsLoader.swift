// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import HTTPClient

public typealias RemoteBestPodcastsLoader = RemoteLoader<BestPodcastsList>

public extension RemoteBestPodcastsLoader {
    convenience init(url: URL, client: HTTPClient) {
        self.init(url: url, client: client, mapper: BestPodastsItemsMapper.map)
    }
}

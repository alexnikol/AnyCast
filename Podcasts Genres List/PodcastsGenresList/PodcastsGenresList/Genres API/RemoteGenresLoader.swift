// Copyright © 2022 Almost Engineer. All rights reserved. 

import Foundation
import HTTPClient

public typealias RemoteGenresLoader = RemoteLoader<[Genre]>

public extension RemoteGenresLoader {
    convenience init(url: URL, client: HTTPClient) {
        self.init(url: url, client: client, mapper: GenresItemsMapper.map)
    }
}

// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public protocol PodcastImageDataCache {
    typealias SaveResult = Result<Void, Error>
    
    func save(_ data: Data, for url: URL, completion: @escaping (SaveResult) -> Void)
}

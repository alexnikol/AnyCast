// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public enum PodcastsImageDataStoreResult {
    case empty
    case found(cache: LocalPocastImageData, timestamp: Date)
    case failure(Error)
}

public protocol PodcastsImageDataStore {
    typealias RetrievalResult = PodcastsImageDataStoreResult
    typealias InsertionResult = Swift.Result<Void, Error>
    
    func retrieve(dataForURL url: URL, completion: @escaping (RetrievalResult) -> Void)
    func insert(_ data: Data, for url: URL, with timestamp: Date, completion: @escaping (InsertionResult) -> Void)
}

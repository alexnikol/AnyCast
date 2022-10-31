// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public struct LocalPocastImageData: Equatable {
    public let data: Data
    
    public init(data: Data) {
        self.data = data
    }
}

public enum PodcastsImageDataStoreResult {
    case empty
    case found(cache: LocalPocastImageData, timestamp: Date)
    case failure(Error)
}

public protocol PodcastsImageDataStore {
    typealias RetrievalResult = PodcastsImageDataStoreResult
    typealias InsertionResult = Swift.Result<Void, Error>
    
    func retrieve(dataForURL url: URL, completion: @escaping (RetrievalResult) -> Void)
    func insert(_ data: Data, for url: URL, completion: @escaping (InsertionResult) -> Void)
}

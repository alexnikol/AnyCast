// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public protocol PodcastsImageDataStore {
    typealias RetrievalResult = Swift.Result<Data?, Error>
    typealias InsertionResult = Error?
    
    func retrieve(dataForURL url: URL, completion: @escaping (RetrievalResult) -> Void)
    func save(_ data: Data, for url: URL, completion: @escaping (InsertionResult) -> Void)
}

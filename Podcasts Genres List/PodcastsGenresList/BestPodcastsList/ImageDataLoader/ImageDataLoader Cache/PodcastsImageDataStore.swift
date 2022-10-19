// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public protocol PodcastsImageDataStore {
    typealias RetrievalResult = Swift.Result<Data?, Error>
    
    func retrieve(dataForURL url: URL, completion: @escaping (RetrievalResult) -> Void)
}

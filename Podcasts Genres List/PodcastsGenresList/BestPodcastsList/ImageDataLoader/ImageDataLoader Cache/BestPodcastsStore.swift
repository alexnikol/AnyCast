// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public protocol BestPodcastsStore {
    typealias Result = Swift.Result<Data?, Error>
    
    func retrieve(dataForURL url: URL, completion: @escaping (Result) -> Void)
}

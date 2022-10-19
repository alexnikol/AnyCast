// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public protocol PodcastImageDataLoaderTask {
    func cancel()
}

public protocol PodcastImageDataLoader {
    typealias Result = Swift.Result<Data, Error>
    
    func loadImageData(from url: URL, completion: @escaping (Result) -> Void) -> PodcastImageDataLoaderTask
}

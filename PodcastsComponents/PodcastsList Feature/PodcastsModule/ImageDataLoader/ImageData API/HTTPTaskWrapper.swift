// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import HTTPClient

final class HTTPTaskWrapper: PodcastImageDataLoaderTask {
    private var completion: ((RemoteImageDataLoader.Result) -> Void)?
    var wrapped: HTTPClientTask?
    
    init(_ completion: @escaping (RemoteImageDataLoader.Result) -> Void) {
        self.completion = completion
    }
    
    func cancel() {
        preventFurtherCompletions()
        wrapped?.cancel()
    }
    
    func complete(with result: RemoteImageDataLoader.Result) {
        completion?(result)
    }
    
    private func preventFurtherCompletions() {
        completion = nil
    }
}

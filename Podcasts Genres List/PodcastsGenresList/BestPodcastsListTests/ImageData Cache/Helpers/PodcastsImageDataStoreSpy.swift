// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import BestPodcastsList

class PodcastsImageDataStoreSpy: PodcastsImageDataStore {
    enum Message: Equatable {
        case retrieve(for: URL)
    }
    
    private(set) var receivedMessages: [Message] = []
    private(set) var requestCompletions: [(PodcastsImageDataStore.RetrievalResult) -> Void] = []
    
    func retrieve(dataForURL url: URL, completion: @escaping (PodcastsImageDataStore.RetrievalResult) -> Void) {
        receivedMessages.append(.retrieve(for: url))
        requestCompletions.append(completion)
    }
    
    func completeRetrieval(with error: Error, at index: Int = 0) {
        requestCompletions[index](.failure(error))
    }
    
    func completeRetrieval(with data: Data?, at index: Int = 0) {
        requestCompletions[index](.success(data))
    }
}

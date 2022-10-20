// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import BestPodcastsList

class PodcastsImageDataStoreSpy: PodcastsImageDataStore {
    enum Message: Equatable {
        case retrieve(for: URL)
        case insert(data: Data, for: URL)
    }
    
    private(set) var receivedMessages: [Message] = []
    
    // MARK: - Retrieve
    
    private(set) var retreiveCompletions: [(PodcastsImageDataStore.RetrievalResult) -> Void] = []
    
    func retrieve(dataForURL url: URL, completion: @escaping (PodcastsImageDataStore.RetrievalResult) -> Void) {
        receivedMessages.append(.retrieve(for: url))
        retreiveCompletions.append(completion)
    }
    
    func completeRetrieval(with error: Error, at index: Int = 0) {
        retreiveCompletions[index](.failure(error))
    }
    
    func completeRetrieval(with data: Data?, at index: Int = 0) {
        retreiveCompletions[index](.success(data))
    }
    
    // MARK: - Insertion
    
    private(set) var insertCompletions: [(PodcastsImageDataStore.InsertionResult) -> Void] = []
    
    func save(_ data: Data, for url: URL, completion: @escaping (InsertionResult) -> Void) {
        receivedMessages.append(.insert(data: data, for: url))
        insertCompletions.append(completion)
    }
    
    func completeInsrertion(with error: Error, at index: Int = 0) {
        insertCompletions[index](.failure(error))
    }
}

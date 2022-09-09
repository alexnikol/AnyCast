// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import PodcastsGenresList

class GenresStoreSpy: GenresStore {
    
    enum ReceivedMessage: Equatable {
        case deleteCache
        case insert([LocalGenre], Date)
        case insertFailure(NSError)
        case retrieve
    }
    
    private(set) var receivedMessages: [ReceivedMessage] = []
    private var deletionCompletions: [DeletionCompletion] = []
    private var insertionCompletions: [InsertionCompletion] = []
    private var retrievalCompletions: [RetrievalCompletion] = []
    
    func deleteCacheGenres(completion: @escaping DeletionCompletion) {
        deletionCompletions.append(completion)
        receivedMessages.append(.deleteCache)
    }
    
    func completeDeletion(with error: NSError, at index: Int = 0) {
        deletionCompletions[index](error)
    }
    
    func completeDeletionSuccessfully(at index: Int = 0) {
        deletionCompletions[index](nil)
    }
    
    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionCompletions[index](error)
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionCompletions[index](nil)
    }
    
    func insert(_ genres: [LocalGenre], timestamp: Date, completion: @escaping InsertionCompletion) {
        insertionCompletions.append(completion)
        receivedMessages.append(.insert(genres, timestamp))
    }
    
    func retrieve(completion: @escaping RetrievalCompletion) {
        retrievalCompletions.append(completion)
        receivedMessages.append(.retrieve)
    }
    
    func completeRetrieval(with error: Error, at index: Int = 0) {
        retrievalCompletions[index](error)
    }
}

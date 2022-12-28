// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import AudioPlayerModule

class PlaybackProgressStoreSpy: PlaybackProgressStore {
    enum Message: Equatable {
        case deleteCache
        case insert(LocalPlayingItem, Date)
    }
    
    private var deletionCompletions: [DeletionCompletion] = []
    private var insertionCompletions: [InsertionCompletion] = []
    private(set) var receivedMessages: [Message] = []
    
    func deleteCachedPlayingItem(completion: @escaping DeletionCompletion) {
        receivedMessages.append(.deleteCache)
        deletionCompletions.append(completion)
    }
    
    func completeDeletion(with error: NSError, at index: Int = 0) {
        deletionCompletions[index](error)
    }
    
    func completeDeletionSuccessfully(at index: Int = 0) {
        deletionCompletions[index](nil)
    }
    
    func insert(_ playingItem: LocalPlayingItem, timestamp: Date, completion: @escaping InsertionCompletion) {
        receivedMessages.append(.insert(playingItem, timestamp))
        insertionCompletions.append(completion)
    }
    
    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionCompletions[index](error)
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionCompletions[index](nil)
    }
}

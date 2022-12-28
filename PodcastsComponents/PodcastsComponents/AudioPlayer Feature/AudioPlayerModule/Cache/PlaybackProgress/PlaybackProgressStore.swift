// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public enum RetrieveCachePlaybackProgressResult {
    case empty
    case found(playingItem: LocalPlayingItem, timestamp: Date)
    case failure(Error)
}

public protocol PlaybackProgressStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    typealias RetrievalCompletion = (RetrieveCachePlaybackProgressResult) -> Void
    
    func deleteCachedPlayingItem(completion: @escaping DeletionCompletion)
    func insert(_ playingItem: LocalPlayingItem, timestamp: Date, completion: @escaping InsertionCompletion)
    func retrieve(completion: @escaping RetrievalCompletion)
}

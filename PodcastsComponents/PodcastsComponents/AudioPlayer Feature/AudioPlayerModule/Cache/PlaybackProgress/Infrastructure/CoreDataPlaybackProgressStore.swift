// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public final class CoreDataPlaybackProgressStore: PlaybackProgressStore {
    
    public init(storeURL: URL) throws {}
    
    public func deleteCachedPlayingItem(completion: @escaping DeletionCompletion) {}
    
    public func insert(_ playingItem: LocalPlayingItem, timestamp: Date, completion: @escaping InsertionCompletion) {}
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        completion(.empty)
    }
}

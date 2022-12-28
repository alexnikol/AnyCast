// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public protocol PlaybackProgressStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    
    func deleteCachedPlayingItem(completion: @escaping DeletionCompletion)
    func insert(_ playingItem: LocalPlayingItem, timestamp: Date, completion: @escaping InsertionCompletion)
}

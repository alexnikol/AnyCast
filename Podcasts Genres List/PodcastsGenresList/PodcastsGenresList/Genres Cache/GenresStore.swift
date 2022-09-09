// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public enum RetrieveCacheFeedResult {
    case empty
    case found(genres: [LocalGenre], timestamp: Date)
    case failure(Error)
}

public protocol GenresStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    typealias RetrievalCompletion = (RetrieveCacheFeedResult) -> Void
    
    func deleteCacheGenres(completion: @escaping DeletionCompletion)
    func insert(_ genres: [LocalGenre], timestamp: Date, completion: @escaping InsertionCompletion)
    func retrieve(completion: @escaping RetrievalCompletion)
}

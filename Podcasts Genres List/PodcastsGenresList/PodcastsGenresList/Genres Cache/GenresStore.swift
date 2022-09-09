// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public protocol GenresStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    typealias RetrievalCompletion = (Error?) -> Void
    
    func deleteCacheGenres(completion: @escaping DeletionCompletion)
    func insert(_ genres: [LocalGenre], timestamp: Date, completion: @escaping InsertionCompletion)
    func retrieve(completion: @escaping RetrievalCompletion)
}

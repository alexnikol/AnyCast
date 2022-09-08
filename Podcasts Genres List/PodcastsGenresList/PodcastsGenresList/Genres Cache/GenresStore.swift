// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public protocol GenresStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    
    func deleteCacheGenres(completion: @escaping DeletionCompletion)
    func insert(_ items: [Genre], timestamp: Date, completion: @escaping InsertionCompletion)
}
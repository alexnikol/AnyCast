// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public protocol GenresStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    
    func deleteCacheGenres(completion: @escaping DeletionCompletion)
    func insert(_ items: [LocalGenre], timestamp: Date, completion: @escaping InsertionCompletion)
}

public struct LocalGenre: Equatable {
    let id: Int
    let name: String
    
    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

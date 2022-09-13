// Copyright © 2022 Almost Engineer. All rights reserved.

import CoreData

public class CoreDataGenresStore: GenresStore {
    
    public func deleteCacheGenres(completion: @escaping DeletionCompletion) {}
    
    public func insert(_ genres: [LocalGenre], timestamp: Date, completion: @escaping InsertionCompletion) {
        
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        completion(.empty)
    }
    
    public init() {}
}

@objc(ManagedGenresStoreCache)
class ManagedGenresStoreCache: NSManagedObject {
    @NSManaged var timestamp: Date
    @NSManaged var genres: NSOrderedSet
}

@objc(ManagedGenre)
class ManagedGenre: NSManagedObject {
    @NSManaged var id: Int
    @NSManaged var name: String
    @NSManaged var cached: ManagedGenresStoreCache
}

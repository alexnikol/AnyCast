// Copyright © 2022 Almost Engineer. All rights reserved.

import CoreData

public class CoreDataGenresStore: GenresStore {
    
    private let container: NSPersistentContainer
    
    public func deleteCacheGenres(completion: @escaping DeletionCompletion) {}
    
    public func insert(_ genres: [LocalGenre], timestamp: Date, completion: @escaping InsertionCompletion) {
        
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        completion(.empty)
    }
    
    public init(bundle: Bundle = .main) throws {
        container = try NSPersistentContainer.load(modelName: "GenresStore", in: bundle)
    }
}

private extension NSPersistentContainer {
     enum LoadingError: Swift.Error {
         case modelNotFound
         case failedToLoadPersistentStores(Swift.Error)
     }

     static func load(modelName name: String, in bundle: Bundle) throws -> NSPersistentContainer {
         guard let model = NSManagedObjectModel.with(name: name, in: bundle) else {
             throw LoadingError.modelNotFound
         }

         let container = NSPersistentContainer(name: name, managedObjectModel: model)
         var loadError: Swift.Error?
         container.loadPersistentStores { loadError = $1 }
         try loadError.map { throw LoadingError.failedToLoadPersistentStores($0) }

         return container
     }
 }

 private extension NSManagedObjectModel {
     static func with(name: String, in bundle: Bundle) -> NSManagedObjectModel? {
         return bundle
             .url(forResource: name, withExtension: "momd")
             .flatMap { NSManagedObjectModel(contentsOf: $0) }
     }
 }

@objc(ManagedGenresStoreCache)
private class ManagedGenresStoreCache: NSManagedObject {
    @NSManaged var timestamp: Date
    @NSManaged var genres: NSOrderedSet
}

@objc(ManagedGenre)
private class ManagedGenre: NSManagedObject {
    @NSManaged var id: Int
    @NSManaged var name: String
    @NSManaged var cached: ManagedGenresStoreCache
}

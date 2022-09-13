// Copyright © 2022 Almost Engineer. All rights reserved.

import CoreData

public final class CoreDataGenresStore: GenresStore {
    
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    public func deleteCacheGenres(completion: @escaping DeletionCompletion) {
        perform { context in
            do {
                try ManagedGenresStoreCache.find(in: context).map(context.delete).map(context.save)
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    public func insert(_ genres: [LocalGenre], timestamp: Date, completion: @escaping InsertionCompletion) {
        perform { context in
            do {
                let managedCache = try ManagedGenresStoreCache.newUniqueInstance(in: context)
                managedCache.timestamp = timestamp
                managedCache.genres = NSOrderedSet(array: genres.toCoreDataModels(in: context))
                
                try context.save()
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        perform { context in
            do {
                let request = NSFetchRequest<ManagedGenresStoreCache>(entityName: ManagedGenresStoreCache.entity().name!)
                request.returnsObjectsAsFaults = false
                
                if let cache = try context.fetch(request).first {
                    let localGenres = cache.genres.compactMap { $0 as? ManagedGenre }.map { $0.local() }
                    completion(.found(genres: localGenres, timestamp: cache.timestamp))
                } else {
                    completion(.empty)
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    public init(storeURL: URL, bundle: Bundle = .main) throws {
        container = try NSPersistentContainer.load(modelName: "GenresStore", url: storeURL, in: bundle)
        context = container.newBackgroundContext()
    }
    
    private func perform(_ action: @escaping (NSManagedObjectContext) -> Void) {
        let context = self.context
        context.perform { action(context) }
    }
}

private extension Array where Element == LocalGenre {
    func toCoreDataModels(in context: NSManagedObjectContext) -> [ManagedGenre] {
        return map { local in
            let managed = ManagedGenre(context: context)
            managed.id = local.id
            managed.name = local.name
            return managed
        }
    }
}

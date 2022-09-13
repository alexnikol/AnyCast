// Copyright © 2022 Almost Engineer. All rights reserved.

import CoreData

@objc(ManagedGenresStoreCache)
final class ManagedGenresStoreCache: NSManagedObject {
    @NSManaged var timestamp: Date
    @NSManaged var genres: NSOrderedSet
}

extension ManagedGenresStoreCache {
    static func find(in context: NSManagedObjectContext) throws -> ManagedGenresStoreCache? {
        let request = NSFetchRequest<ManagedGenresStoreCache>(entityName: entity().name!)
        request.returnsObjectsAsFaults = false
        return try context.fetch(request).first
    }
    
    static func newUniqueInstance(in context: NSManagedObjectContext) throws -> ManagedGenresStoreCache {
         try find(in: context).map(context.delete)
         return ManagedGenresStoreCache(context: context)
     }
}

extension ManagedGenresStoreCache {
    func localGenres() -> [LocalGenre] {
        return genres.compactMap { $0 as? ManagedGenre }.map { LocalGenre(id: $0.id, name: $0.name) }
    }
}

extension ManagedGenresStoreCache {
    static func toCoreDataGenres(from localGenres: [LocalGenre], in context: NSManagedObjectContext) -> NSOrderedSet {
        return NSOrderedSet(array: localGenres.map { local in
            let managed = ManagedGenre(context: context)
            managed.id = local.id
            managed.name = local.name
            return managed
        })
    }
}

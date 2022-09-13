// Copyright © 2022 Almost Engineer. All rights reserved.

import CoreData

@objc(ManagedGenresStoreCache)
class ManagedGenresStoreCache: NSManagedObject {
    @NSManaged var timestamp: Date
    @NSManaged var genres: NSOrderedSet
    
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

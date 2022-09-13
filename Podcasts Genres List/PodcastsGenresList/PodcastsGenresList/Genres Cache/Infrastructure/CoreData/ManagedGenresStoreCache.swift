// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import CoreData

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

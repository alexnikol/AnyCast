// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import CoreData

@objc(ManagedPodcastImage)
final class ManagedPodcastImage: NSManagedObject {
    @NSManaged var data: Data
    @NSManaged var url: URL
    @NSManaged var timestamp: Date
}

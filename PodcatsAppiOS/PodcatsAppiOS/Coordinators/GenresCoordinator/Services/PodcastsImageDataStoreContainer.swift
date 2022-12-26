// Copyright © 2022 Almost Engineer. All rights reserved.

import CoreData
import PodcastsModule

final class PodcastsImageDataStoreContainer {
    static let shared = PodcastsImageDataStoreContainer()
    
    lazy var podcastsImageDataStore: PodcastsImageDataStore = {
        try! CoreDataPodcastsImageDataStore(
            storeURL: NSPersistentContainer
                .defaultDirectoryURL()
                .appendingPathComponent("best-podcasts-image-data-store.sqlite")
        )
    }()
}

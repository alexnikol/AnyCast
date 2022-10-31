// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import CoreData

public final class CoreDataPodcastsImageDataStore: PodcastsImageDataStore {
    
    private let storeURL: URL
    private let storeBundle: Bundle
    private let currentDate: () -> Date
    private let storeName = "PodcastsImageDataStore"
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    public init(storeURL: URL, currentDate: @escaping () -> Date) throws {
        self.storeURL = storeURL
        storeBundle = Bundle(for: Self.self)
        self.currentDate = currentDate
        let model = Bundle(for: Self.self)
            .url(forResource: storeName, withExtension: "momd")
            .flatMap { NSManagedObjectModel(contentsOf: $0) }!
        container = NSPersistentContainer(name: storeName, managedObjectModel: model)
        container.persistentStoreDescriptions = [NSPersistentStoreDescription(url: storeURL)]
        var loadError: Error?
        container.loadPersistentStores(completionHandler: { _, error in
            loadError = error
        })
        if let existedLoadError = loadError {
            throw existedLoadError
        }
        context = container.newBackgroundContext()
    }
    
    public func retrieve(dataForURL url: URL, completion: @escaping (RetrievalResult) -> Void) {
        let context = self.context
        context.perform {
            do {
                let request = NSFetchRequest<ManagedPodcastImage>(entityName: ManagedPodcastImage.entity().name!)
                request.returnsObjectsAsFaults = false
                request.fetchLimit = 1
                request.predicate = NSPredicate(format: "url == %@", url as CVarArg)
                
                if let cache = try context.fetch(request).first {
                    let image = LocalPocastImageData(data: cache.data)
                    completion(.found(cache: image, timestamp: cache.timestamp))
                } else {
                    completion(.empty)
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    public func insert(_ data: Data, for url: URL, completion: @escaping (InsertionResult) -> Void) {
        let date = currentDate()
        let context = self.context
        context.perform {
            do {
                let request = NSFetchRequest<ManagedPodcastImage>(entityName: ManagedPodcastImage.entity().name!)
                request.returnsObjectsAsFaults = false
                request.fetchLimit = 1
                request.predicate = NSPredicate(format: "url == %@", url as CVarArg)
                try context.fetch(request).first.map(context.delete)
                
                let cacheImage = ManagedPodcastImage(context: context)
                cacheImage.timestamp = date
                cacheImage.data = data
                cacheImage.url = url
                
                try context.save()
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
}

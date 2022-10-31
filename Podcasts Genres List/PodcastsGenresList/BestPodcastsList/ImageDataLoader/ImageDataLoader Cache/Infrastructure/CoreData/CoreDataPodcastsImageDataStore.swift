// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import CoreData

public final class CoreDataPodcastsImageDataStore: PodcastsImageDataStore {
    
    private let storeURL: URL
    private let storeBundle: Bundle
    private let currentDate: () -> Date
    private let storeName = "PodcastsImageDataStore"
    private let container: NSPersistentContainer
    
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
    }
    
    public func retrieve(dataForURL url: URL, completion: @escaping (RetrievalResult) -> Void) {
        completion(.success(.none))
    }
    
    public func insert(_ data: Data, for url: URL, completion: @escaping (InsertionResult) -> Void) {
        let date = currentDate()
        let context = container.newBackgroundContext()
        context.perform {
            let cacheImage = ManagedPodcastImage(context: context)
            cacheImage.timestamp = date
            cacheImage.data = data
            cacheImage.url = url
            
            do {
                try context.save()
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
}

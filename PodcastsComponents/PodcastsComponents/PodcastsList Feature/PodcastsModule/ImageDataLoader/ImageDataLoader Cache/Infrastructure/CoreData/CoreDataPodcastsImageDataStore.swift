// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import CoreData

public final class CoreDataPodcastsImageDataStore: PodcastsImageDataStore {
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    public init(storeURL: URL) throws {
        container = try NSPersistentContainer.load(modelName: "PodcastsImageDataStore", url: storeURL, in: Bundle(for: Self.self))
        context = container.newBackgroundContext()
    }
    
    public func retrieve(dataForURL url: URL, completion: @escaping (RetrievalResult) -> Void) {
        let context = self.context
        let request = fetchImageDataRequest(by: url)
        context.perform {
            do {
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
    
    public func insert(_ data: Data, for url: URL, with timestamp: Date, completion: @escaping (InsertionResult) -> Void) {
        let context = self.context
        let request = fetchImageDataRequest(by: url)
        context.perform {
            do {
                try context.fetch(request).first.map(context.delete)
                
                let cacheImage = ManagedPodcastImage(context: context)
                cacheImage.timestamp = timestamp
                cacheImage.data = data
                cacheImage.url = url
                
                try context.save()
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    private func fetchImageDataRequest(by url: URL) -> NSFetchRequest<ManagedPodcastImage> {
        let request = NSFetchRequest<ManagedPodcastImage>(entityName: ManagedPodcastImage.entity().name!)
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "url == %@", url as CVarArg)
        return request
    }
}

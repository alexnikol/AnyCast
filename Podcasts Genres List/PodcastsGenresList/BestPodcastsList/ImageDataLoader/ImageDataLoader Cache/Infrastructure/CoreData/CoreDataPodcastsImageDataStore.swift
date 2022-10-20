// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import CoreData

public final class CoreDataPodcastsImageDataStore: PodcastsImageDataStore {
    
    private let storeURL: URL
    private let storeBundle: Bundle
    
    public init(storeURL: URL) {
        self.storeURL = storeURL
        storeBundle = Bundle(for: Self.self)
    }
    
    public func retrieve(dataForURL url: URL, completion: @escaping (RetrievalResult) -> Void) {
        completion(.success(.none))
    }
    
    public func insert(_ data: Data, for url: URL, completion: @escaping (InsertionResult) -> Void) {}
}

// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public class LocalGenresLoader {
    
    public typealias SaveResult = Error?
    
    private let store: GenresStore
    private let currentDate: () -> Date
    
    public init(store: GenresStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
        
    public func save(_ items: [Genre], completion: @escaping (SaveResult) -> Void) {
        store.deleteCacheGenres { [weak self] error in
            guard let self = self else { return }
            
            if let cacheDeletionError = error {
                completion(cacheDeletionError)
            } else {
                self.cache(items, completion: completion)
            }
        }
    }
    
    private func cache(_ items: [Genre], completion: @escaping (SaveResult) -> Void) {
        store.insert(items, timestamp: currentDate(), completion: { [weak self] error in
            guard self != nil else {
                return
            }
            completion(error)
        })
    }
}

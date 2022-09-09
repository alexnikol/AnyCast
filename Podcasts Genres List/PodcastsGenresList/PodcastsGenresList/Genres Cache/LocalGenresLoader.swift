// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public class LocalGenresLoader {
    
    public typealias SaveResult = Error?
    public typealias LoadResult = LoadGenresResult
    
    private let store: GenresStore
    private let currentDate: () -> Date
    
    public init(store: GenresStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
        
    public func save(_ genres: [Genre], completion: @escaping (SaveResult) -> Void) {
        store.deleteCacheGenres { [weak self] error in
            guard let self = self else { return }
            
            if let cacheDeletionError = error {
                completion(cacheDeletionError)
            } else {
                self.cache(genres, completion: completion)
            }
        }
    }
    
    public func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .found(localGenres, timestamp) where self.validate(timestamp):
                completion(.success(localGenres.toModels()))
                
            case .found, .empty:
                completion(.success([]))
                                
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    public func validateCache() {
        store.retrieve { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .failure:
                self.store.deleteCacheGenres { _ in }
                
            case let .found(_, timestamp) where !self.validate(timestamp):
                self.store.deleteCacheGenres { _ in }
                
            case .empty, .found: break
            }
        }
    }
    
    private var maxCacheAgeInDays: Int {
        return 7
    }
    
    private func validate(_ timestamp: Date) -> Bool {
        let calendar = Calendar(identifier: .gregorian)
        guard let maxCacheAge = calendar.date(byAdding: .day, value: maxCacheAgeInDays, to: timestamp) else {
            return false
        }
        return currentDate() < maxCacheAge
    }
    
    private func cache(_ genres: [Genre], completion: @escaping (SaveResult) -> Void) {
        store.insert(genres.toLocal(), timestamp: currentDate(), completion: { [weak self] error in
            guard self != nil else {
                return
            }
            completion(error)
        })
    }
}

private extension Array where Element == Genre {
    func toLocal() -> [LocalGenre] {
        return map { .init(id: $0.id, name: $0.name) }
    }
}

private extension Array where Element == LocalGenre {
    func toModels() -> [Genre] {
        return map { .init(id: $0.id, name: $0.name) }
    }
}

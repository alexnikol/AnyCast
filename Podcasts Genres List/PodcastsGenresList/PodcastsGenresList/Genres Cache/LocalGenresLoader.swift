// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

private final class GenresCachePolicy {
    
    private init() {}
    
    private static let calendar = Calendar(identifier: .gregorian)
        
    private static var maxCacheAgeInDays: Int {
        return 7
    }
    
    static func validate(_ timestamp: Date, against date: Date) -> Bool {
        guard let maxCacheAge = calendar.date(byAdding: .day, value: maxCacheAgeInDays, to: timestamp) else {
            return false
        }
        return date < maxCacheAge
    }
}

public class LocalGenresLoader {
    private let store: GenresStore
    private let currentDate: () -> Date
    
    public init(store: GenresStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
}

extension LocalGenresLoader {
    
    public typealias SaveResult = Error?
    
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
    
    private func cache(_ genres: [Genre], completion: @escaping (SaveResult) -> Void) {
        store.insert(genres.toLocal(), timestamp: currentDate(), completion: { [weak self] error in
            guard self != nil else {
                return
            }
            completion(error)
        })
    }
}

extension LocalGenresLoader: GenresLoader {
    
    public typealias LoadResult = LoadGenresResult
    
    public func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case let .found(localGenres, timestamp) where GenresCachePolicy.validate(timestamp, against: self.currentDate()):
                completion(.success(localGenres.toModels()))
                
            case .found, .empty:
                completion(.success([]))
                                
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

extension LocalGenresLoader {
    
    public func validateCache() {
        store.retrieve { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .failure:
                self.store.deleteCacheGenres { _ in }
                
            case let .found(_, timestamp) where !GenresCachePolicy.validate(timestamp, against: self.currentDate()):
                self.store.deleteCacheGenres { _ in }
                
            case .empty, .found: break
            }
        }
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

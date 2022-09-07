// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import PodcastsGenresList

class LocalGenresLoader {
    
    private let store: GenresStore
    
    init(store: GenresStore) {
        self.store = store
    }
    
    func save(_ items: [Genre]) {
        store.deleteCacheGenres()
    }
}

class GenresStore {
    var deleteCachedGenresCallCount = 0
    
    func deleteCacheGenres() {
        deleteCachedGenresCallCount += 1
    }
}

class CacheGenresUseCaseTests: XCTestCase {
    
    func test_init_doesNotDeleteCacheUponCreation() {
        let store = GenresStore()
        _ = LocalGenresLoader(store: store)
        
        XCTAssertEqual(store.deleteCachedGenresCallCount, 0)
    }
    
    func test_save_requestsCacheDeletion() {
        
        let store = GenresStore()
        let sut = LocalGenresLoader(store: store)
        let items: [Genre] = [uniqueItem(id: 1), uniqueItem(id: 2)]
        
        sut.save(items)
        
        XCTAssertEqual(store.deleteCachedGenresCallCount, 1)
    }
    
    // MARK: - Helpers
    
    private func uniqueItem(id: Int) -> Genre {
        .init(id: id, name: "any genre")
    }
}

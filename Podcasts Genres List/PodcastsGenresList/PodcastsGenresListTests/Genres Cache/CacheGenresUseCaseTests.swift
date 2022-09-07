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
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.deleteCachedGenresCallCount, 0)
    }
    
    func test_save_requestsCacheDeletion() {
        
        let (sut, store) = makeSUT()
        let items: [Genre] = [uniqueItem(id: 1), uniqueItem(id: 2)]
        
        sut.save(items)
        
        XCTAssertEqual(store.deleteCachedGenresCallCount, 1)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: LocalGenresLoader, store: GenresStore) {
        let store = GenresStore()
        let sut = LocalGenresLoader(store: store)
        return (sut, store)
    }
    
    private func uniqueItem(id: Int) -> Genre {
        .init(id: id, name: "any genre")
    }
}

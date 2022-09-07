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
    
    var insertCallCount = 0
    
    func completeDeletion(with: NSError) {}
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
    
    func test_save_doesNotRequestCacheInsertionOnDeletionError() {
        let (sut, store) = makeSUT()
        let items: [Genre] = [uniqueItem(id: 1), uniqueItem(id: 2)]
        let deletionError = anyNSError()
        
        sut.save(items)
        store.completeDeletion(with: deletionError)
        
        XCTAssertEqual(store.insertCallCount, 0)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: LocalGenresLoader, store: GenresStore) {
        let store = GenresStore()
        let sut = LocalGenresLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func uniqueItem(id: Int) -> Genre {
        .init(id: id, name: "any genre")
    }
    
    private func anyNSError() -> NSError {
        NSError(domain: "any error", code: 0)
    }
}

// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import PodcastsGenresList

class CoreDataGenresStore: GenresStore {
    
    func deleteCacheGenres(completion: @escaping DeletionCompletion) {}
    
    func insert(_ genres: [LocalGenre], timestamp: Date, completion: @escaping InsertionCompletion) {}
    
    func retrieve(completion: @escaping RetrievalCompletion) {
        completion(.empty)
    }
}

class CoreDataGenresStoreTests: XCTestCase, GenresStoreSpecs {
    
    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = makeSUT()
        
        assertThatRetrieveDeliversEmptyOnEmptyCache(on: sut)
    }
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        
        assertThatRetrieveHasNoSideEffectsOnEmptyCache(on: sut)
    }
    
    func test_retrieve_deliversFoundValuesOnNonEmptyCache() {}
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {}
    
    func test_insert_deliversNoErrorOnEmptyCache() {}
    
    func test_insert_deliversNoErrorOnNonEmptyCache() {}
    
    func test_insert_overridesPreviouslyInsertedCacheValues() {}
    
    func test_delete_deliversNoErrorOnEmptyCache() {}
    
    func test_delete_hasNoSideEffectsOnEmptyCache() {}
    
    func test_delete_deliversNoErrorOnNonEmptyCache() {}
    
    func test_delete_hasNoSideEffectsOnNonEmptyCache() {}
    
    func test_storeSideEffects_runSerially() {}
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> GenresStore {
        let sut = CoreDataGenresStore()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}

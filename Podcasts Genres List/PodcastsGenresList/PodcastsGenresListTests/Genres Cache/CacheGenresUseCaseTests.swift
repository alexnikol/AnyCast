// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest

class GenresStore {
    var deleteCachedGenresCallCount = 0
}

class LocalGenresLoader {
    init(store: GenresStore) {}
}

class CacheGenresUseCaseTests: XCTestCase {
    
    func test_init_doesNotDeleteCacheUponCreation() {
        let store = GenresStore()
        _ = LocalGenresLoader(store: store)
        
        XCTAssertEqual(store.deleteCachedGenresCallCount, 0)
    }
}

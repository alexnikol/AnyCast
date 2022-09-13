// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest

class CoreDataGenresStoreTests: XCTest, GenresStoreSpecs {
    
    func test_retrieve_deliversEmptyOnEmptyCache() {}
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() {}
    
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
}

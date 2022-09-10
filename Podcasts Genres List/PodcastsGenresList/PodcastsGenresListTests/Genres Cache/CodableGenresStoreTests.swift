// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import PodcastsGenresList

class CodableGenresStore {
    func retrieve(completion: @escaping GenresStore.RetrievalCompletion) {
        completion(.empty)
    }
}

class CodableGenresStoreTests: XCTestCase {
    
    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = CodableGenresStore()
        let exp = expectation(description: "Wait for cache retrieval")
        
        var receivedResult: RetrieveCacheFeedResult?
        sut.retrieve { result in
            switch result {
            case .empty:
                receivedResult = result
                
            default:
                XCTFail("Expected empty result, got \(result) instead")
            }
        
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertNotNil(receivedResult)
    }
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        let sut = CodableGenresStore()
        let exp = expectation(description: "Wait for cache retrieval")
        
        sut.retrieve { firstResult in
            sut.retrieve { secondResult in
                switch (firstResult, secondResult) {
                case (.empty, .empty):
                    break
                    
                default:
                    XCTFail("Expected retrieving twice from empty cache to deliver same result, got \(firstResult) and \(secondResult) instead")
                }
            
                exp.fulfill()
            }
        }
        
        wait(for: [exp], timeout: 1.0)
    }
}

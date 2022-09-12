// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import PodcastsGenresList

extension GenresStoreSpecs where Self: XCTestCase {
    
    @discardableResult
    func insert(_ cache: (genres: [LocalGenre], timestamp: Date),
                        to sut: GenresStore) -> Error? {
        var insertionError: Error?
        let exp = expectation(description: "Wait for cache insertion")
        sut.insert(cache.genres, timestamp: cache.timestamp) { receivedInsertionError in
            insertionError = receivedInsertionError
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        return insertionError
    }
    
    @discardableResult
    func deleteCache(from sut: GenresStore) -> Error? {
        let exp = expectation(description: "Wait on deletion comletion")
        
        var deletionError: Error?
        sut.deleteCacheGenres { error in
            deletionError = error
            
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        return deletionError
    }
    
    func expect(_ sut: GenresStore,
                        toRetrieveTwice expectedResult: RetrieveCacheGenresResult,
                        file: StaticString = #file,
                        line: UInt = #line) {
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
    }
    
    func expect(_ sut: GenresStore,
                        toRetrieve expectedResult: RetrieveCacheGenresResult,
                        file: StaticString = #file,
                        line: UInt = #line) {
        let exp = expectation(description: "Wait for cache retrieval")
        
        sut.retrieve { retrievedResult in
            switch (expectedResult, retrievedResult) {
            case (.empty, .empty),
                (.failure, .failure):
                break
                
            case let (.found(expectedGenres, expectedTimestamp), .found(retrievedGenres, retrievedTimestamp)):
                XCTAssertEqual(expectedGenres, retrievedGenres, file: file, line: line)
                XCTAssertEqual(expectedTimestamp, retrievedTimestamp, file: file, line: line)
                
            default:
                XCTFail("Expected to retrieve \(expectedResult), got \(retrievedResult) instead", file: file, line: line)
            }
        
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
}

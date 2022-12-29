// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import SharedTestHelpersLibrary
import AudioPlayerModule

final class CoreDataPlaybackProgressStoreTests: XCTestCase {
    
    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = makeSUT()
        
        expect(sut, toRetrieve: .empty)
    }
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        
        expect(sut, toRetrieve: .empty)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> PlaybackProgressStore {
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try! CoreDataPlaybackProgressStore(storeURL: storeURL)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    func expect(_ sut: PlaybackProgressStore,
                toRetrieve expectedResult: RetrieveCachePlaybackProgressResult,
                file: StaticString = #file,
                line: UInt = #line) {
        let exp = expectation(description: "Wait for cache retrieval")
        
        sut.retrieve { retrievedResult in
            switch (expectedResult, retrievedResult) {
            case (.empty, .empty),
                (.failure, .failure):
                break
                
            case let (.found(expectedPlaybackProgress, expectedTimestamp), .found(retrievedPlaybackProgress, retrievedTimestamp)):
                XCTAssertEqual(expectedPlaybackProgress, retrievedPlaybackProgress, file: file, line: line)
                XCTAssertEqual(expectedTimestamp, retrievedTimestamp, "\(expectedTimestamp.timeIntervalSince1970) - \(retrievedTimestamp.timeIntervalSince1970)", file: file, line: line)
                
            default:
                XCTFail("Expected to retrieve \(expectedResult), got \(retrievedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
}

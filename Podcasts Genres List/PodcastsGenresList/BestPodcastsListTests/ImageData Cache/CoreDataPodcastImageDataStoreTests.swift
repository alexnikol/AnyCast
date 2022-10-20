// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import BestPodcastsList

class CoreDataPodcastImageDataStoreTests: XCTestCase {
    
    func test_retrieveImageData_deliversNotFoundWhenEmpty() {
        let sut = makeSUT()
        
        expect(sut, toCompleteWith: notFound())
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> PodcastsImageDataStore {
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = CoreDataPodcastsImageDataStore(storeURL: storeURL)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func expect(
        _ sut: PodcastsImageDataStore,
        toCompleteWith expectedResult: PodcastsImageDataStore.RetrievalResult,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let exp = expectation(description: "Wait for load completion")
        sut.retrieve(dataForURL: anyURL(), completion: { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success( receivedData), .success(expectedData)):
                XCTAssertEqual(receivedData, expectedData, file: file, line: line)
                
            default:
                XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        })
        wait(for: [exp], timeout: 1.0)
    }
    
    private func notFound() -> PodcastsImageDataStore.RetrievalResult {
        return .success(.none)
    }
}

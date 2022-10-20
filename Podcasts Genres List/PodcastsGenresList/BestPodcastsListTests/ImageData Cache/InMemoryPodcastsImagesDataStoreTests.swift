// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import BestPodcastsList

struct LocalPodcastImageData {
    private let timestamp: Date
    private let data: Data
}

class InMemoryPodcastsImagesDataStore: PodcastsImageDataStore {
    
    private var storage: [URL: LocalPodcastImageData] = [:]
    
    func retrieve(dataForURL url: URL, completion: @escaping (RetrievalResult) -> Void) {
        completion(.success(.none))
    }
    
    func insert(_ data: Data, for url: URL, completion: @escaping (InsertionResult) -> Void) {
        completion(.success(()))
    }
}

class InMemoryPodcastsImagesDataStoreTests: XCTestCase {
    
    func test_retrieveImageData_deliversNotFoundWhenEmpty() {
        let sut = makeSUT()
        
        expect(sut, toCompleteRetrievalWith: notFound(), for: anyURL())
    }
    
    func test_retrieveImageData_deliversNotFoundWhenStoredDataURLDoesNotMatch() {
        let sut = makeSUT()
        let url = URL(string: "http://a-url.com")!
        let nonMatchingURL = URL(string: "http://another-url.com")!
        
        insert(anyData(), for: url, into: sut)
        
        expect(sut, toCompleteRetrievalWith: notFound(), for: nonMatchingURL)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> PodcastsImageDataStore {
        let sut = InMemoryPodcastsImagesDataStore()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func expect(
        _ sut: PodcastsImageDataStore,
        toCompleteRetrievalWith expectedResult: PodcastsImageDataStore.RetrievalResult,
        for url: URL,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let exp = expectation(description: "Wait for load completion")
        sut.retrieve(dataForURL: url, completion: { receivedResult in
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
    
    private func insert(
        _ data: Data,
        for url: URL,
        into sut: PodcastsImageDataStore,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let exp = expectation(description: "Wait for cache insertion")
        
        sut.insert(data, for: url) { result in
            if case let Result.failure(error) = result {
                XCTFail("Failed to insert \(data) with error \(error)", file: file, line: line)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    private func notFound() -> PodcastsImageDataStore.RetrievalResult {
        return .success(.none)
    }
}

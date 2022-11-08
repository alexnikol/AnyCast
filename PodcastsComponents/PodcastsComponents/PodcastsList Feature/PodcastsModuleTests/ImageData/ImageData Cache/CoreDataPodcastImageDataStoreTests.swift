// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import PodcastsModule

class CoreDataPodcastImageDataStoreTests: XCTestCase {
    
    func test_retrieveImageData_deliversNotFoundWhenEmpty() {
        let sut = makeSUT()
        
        expect(sut, toCompleteRetrievalWith: notFound(), for: anyURL())
    }
    
    func test_retrieveImageData_deliversNotFoundWhenStoredDataURLDoesNotMatch() {
        let sut = makeSUT()
        let url = URL(string: "http://a-url.com")!
        let nonMatchingURL = URL(string: "http://another-url.com")!
        
        insert(anyData(), for: url, with: now, into: sut)
        
        expect(sut, toCompleteRetrievalWith: notFound(), for: nonMatchingURL)
    }
    
    func test_retrieveImageData_deliversFoundDataWhenThereIsAStoredImageDataMatchingURL() {
        let cacheDate = now
        let sut = makeSUT()
        let url = URL(string: "http://a-url.com")!
        let storedData = anyData()
        
        insert(storedData, for: url, with: cacheDate, into: sut)
        
        expect(sut, toCompleteRetrievalWith: found(storedData, timestamp: cacheDate), for: url)
    }
    
    func test_retrieveImageData_deliversLastInsertedValue() {
        let sut = makeSUT()
        let firstStoredData = Data("first".utf8)
        let firstCacheDate = now
        let lastStoredData = Data("last".utf8)
        let lastCacheDate = now
        let url = URL(string: "http://a-url.com")!
        
        insert(firstStoredData, for: url, with: firstCacheDate, into: sut)
        insert(lastStoredData, for: url, with: lastCacheDate, into: sut)
        
        expect(sut, toCompleteRetrievalWith: found(lastStoredData, timestamp: lastCacheDate), for: url)
    }
    
    func test_sideEffects_runSerially() {
        let sut = makeSUT()
        let url = anyURL()
        
        let op1 = expectation(description: "Operation 1")
        sut.insert(anyData(), for: url, with: Date.init()) { _ in op1.fulfill() }
        
        let op2 = expectation(description: "Operation 2")
        sut.insert(anyData(), for: url, with: Date.init()) { _ in    op2.fulfill() }
        
        let op3 = expectation(description: "Operation 3")
        sut.insert(anyData(), for: url, with: Date.init()) { _ in op3.fulfill() }
        
        wait(for: [op1, op2, op3], timeout: 5.0, enforceOrder: true)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> PodcastsImageDataStore {
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try! CoreDataPodcastsImageDataStore(storeURL: storeURL)
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
                
            case let (.found(receivedCache, receivedTimestamp), .found(expectedCache, expectedTimestamp)):
                XCTAssertEqual(receivedCache, expectedCache, file: file, line: line)
                XCTAssertEqual(receivedTimestamp, expectedTimestamp, file: file, line: line)
                
            case (.empty, .empty):
                break
                
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
        with currentDate: Date,
        into sut: PodcastsImageDataStore,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let exp = expectation(description: "Wait for cache insertion")
        
        sut.insert(data, for: url, with: currentDate) { result in
            if case let Result.failure(error) = result {
                XCTFail("Failed to insert \(data) with error \(error)", file: file, line: line)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    private func notFound() -> PodcastsImageDataStore.RetrievalResult {
        return .empty
    }
    
    private func found(_ storedData: Data, timestamp: Date) -> PodcastsImageDataStore.RetrievalResult {
        return .found(cache: LocalPocastImageData(data: storedData), timestamp: timestamp)
    }
    
    private var now: Date {
        return Date()
    }
}

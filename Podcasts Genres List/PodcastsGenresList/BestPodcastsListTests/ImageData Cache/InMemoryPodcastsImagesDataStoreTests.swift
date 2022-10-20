// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import BestPodcastsList

struct LocalPodcastImageData {
    let timestamp: Date
    let data: Data
}

class InMemoryPodcastsImagesDataStore: PodcastsImageDataStore {
    
    private enum RetrieveError: Error {
        case notFound
    }
    
    private var storage: [URL: LocalPodcastImageData] = [:]
    
    func retrieve(dataForURL url: URL, completion: @escaping (RetrievalResult) -> Void) {
        if let foundData = storage[url] {
            completion(.success(foundData.data))
        } else {
            completion(.success(nil))
        }
    }
    
    func insert(_ data: Data, for url: URL, completion: @escaping (InsertionResult) -> Void) {
        storage[url] = LocalPodcastImageData(timestamp: Date(), data: data)
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
    
    func test_retrieveImageData_deliversFoundDataWhenThereIsAStoredImageDataMatchingURL() {
        let sut = makeSUT()
        let url = URL(string: "http://a-url.com")!
        let storedData = anyData()
        
        insert(storedData, for: url, into: sut)
        
        expect(sut, toCompleteRetrievalWith: found(storedData), for: url)
    }
    
    func test_retrieveImageData_deliversLastInsertedValue() {
        let sut = makeSUT()
        let firstStoredData = Data("first".utf8)
        let lastStoredData = Data("last".utf8)
        let url = URL(string: "http://a-url.com")!
        
        insert(firstStoredData, for: url, into: sut)
        insert(lastStoredData, for: url, into: sut)
        
        expect(sut, toCompleteRetrievalWith: found(lastStoredData), for: url)
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
    
    private func found(_ storedData: Data) -> PodcastsImageDataStore.RetrievalResult {
        return .success(storedData)
    }
}

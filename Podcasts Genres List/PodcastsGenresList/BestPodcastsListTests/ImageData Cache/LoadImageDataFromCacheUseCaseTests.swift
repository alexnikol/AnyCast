// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import BestPodcastsList

protocol BestPodcastsStore {
    func retrieve(dataForURL url: URL, completion: @escaping (Result<Data, Error>) -> Void)
}

class LocalPodcastsImageDataLoader {
    private class Task: ImageDataLoaderTask {
        func cancel() {}
    }
    
    private let store: BestPodcastsStore
    
    init(store: BestPodcastsStore) {
        self.store = store
    }
    
    func loadImageData(from url: URL, completion: @escaping (ImageDataLoader.Result) -> Void) -> ImageDataLoaderTask {
        store.retrieve(dataForURL: url) { result in
            switch result {
            case let .failure(error):
                completion(.failure(error))
                
            default: break
            }
        }
        return Task()
    }
}

class LoadImageDataFromCacheUseCaseTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertTrue(store.receivedMessages.isEmpty)
    }
    
    func test_loadImageDataFromURL_requestsStoredDataForURL() {
        let (sut, store) = makeSUT()
        let url = anyURL()
        
        _ = sut.loadImageData(from: url) { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.retrieve(for: url)])
    }
    
    func test_loadImageDataFromURL_deliversErrorOnStoreRetrivalError() {
        let (sut, store) = makeSUT()
        
        let retrievalError = anyNSError()
        expect(sut, toCompleteWith: .failure(retrievalError), when: {
            store.completeRetrieval(with: retrievalError)
        })
    }
    
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) -> (sut: LocalPodcastsImageDataLoader, store: StoreSpy) {
        let store = StoreSpy()
        let sut = LocalPodcastsImageDataLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func expect(
        _ sut: LocalPodcastsImageDataLoader,
        toCompleteWith expectedResult: Result<Data, Error>,
        when action: () -> Void,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let exp = expectation(description: "Wait on retrieval")
        
        _ = sut.loadImageData(from: anyURL()) { receivedResult in
            switch (expectedResult, receivedResult) {
            case (let .success(expectedData), let .success(receivedData)):
                XCTAssertEqual(expectedData, receivedData, file: file, line: line)
                
            case (let .failure(expectedError as NSError), let .failure(receivedError as NSError)):
                XCTAssertEqual(expectedError, receivedError, file: file, line: line)
                
            default:
                XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private func anyURL() -> URL {
        URL(string: "http://a-url.com")!
    }
    
    func anyNSError() -> NSError {
        NSError(domain: "any error", code: 0)
    }
    
    private func anyData() -> Data {
        Data("any data".utf8)
    }
    
    private class StoreSpy: BestPodcastsStore {
        enum Message: Equatable {
            case retrieve(for: URL)
        }
        
        private(set) var receivedMessages: [Message] = []
        private(set) var requestCompletions: [(Result<Data, Error>) -> Void] = []
        
        func retrieve(dataForURL url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
            receivedMessages.append(.retrieve(for: url))
            requestCompletions.append(completion)
        }
        
        func completeRetrieval(with error: Error, at index: Int = 0) {
            requestCompletions[index](.failure(error))
        }
    }
}

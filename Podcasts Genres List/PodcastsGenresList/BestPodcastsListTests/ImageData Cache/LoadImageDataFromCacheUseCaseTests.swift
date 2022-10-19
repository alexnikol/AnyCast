// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import BestPodcastsList

protocol BestPodcastsStore {
    typealias Result = Swift.Result<Data?, Error>
    
    func retrieve(dataForURL url: URL, completion: @escaping (Result) -> Void)
}

class LocalPodcastsImageDataLoader {
    private class Task: ImageDataLoaderTask {
        private var completion: ((ImageDataLoader.Result) -> Void)?
        
        init(completion: @escaping (ImageDataLoader.Result) -> Void) {
            self.completion = completion
        }
        
        func cancel() {
            preventFurtherCompletions()
        }
        
        private func preventFurtherCompletions() {
            completion = nil
        }
        
        func complete(with result: ImageDataLoader.Result) {
            completion?(result)
        }
    }
    
    public enum Error: Swift.Error {
        case failed
        case notFound
    }
    
    private let store: BestPodcastsStore
    
    init(store: BestPodcastsStore) {
        self.store = store
    }
    
    func loadImageData(from url: URL, completion: @escaping (ImageDataLoader.Result) -> Void) -> ImageDataLoaderTask {
        let task = Task(completion: completion)
        
        store.retrieve(dataForURL: url) { result in
            task.complete(with: result
                .mapError { _ in Error.failed }
                .flatMap { data in
                    data.map { .success($0) } ?? .failure(Error.notFound)
                }
            )
        }
        return task
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
        
        expect(sut, toCompleteWith: failure(.failed), when: {
            store.completeRetrieval(with: anyNSError())
        })
    }
    
    func test_loadImageDataFromURL_deliversNotFoundErrorOnNotFound() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWith: failure(.notFound), when: {
            store.completeRetrieval(with: .none)
        })
    }
    
    func test_loadImageDataFromURL_deliversStoredDataWhenStoreFoundDataForURL() {
        let (sut, store) = makeSUT()
        
        let storedData = anyData()
        expect(sut, toCompleteWith: .success(storedData), when: {
            store.completeRetrieval(with: storedData)
        })
    }
    
    func test_loadImageDataFromURL_doesNotDeliverResultAfterCancellingTask() {
        let (sut, store) = makeSUT()
        let foundData = anyData()
        
        var received: [ImageDataLoader.Result] = []
        let task = sut.loadImageData(from: anyURL(), completion: { received.append($0) })
        task.cancel()
        
        store.completeRetrieval(with: anyNSError())
        store.completeRetrieval(with: .none)
        store.completeRetrieval(with: foundData)
        
        XCTAssertTrue(received.isEmpty, "Expected no received results after cancelling task")
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
                
            case (.failure(let expectedError as LocalPodcastsImageDataLoader.Error),
                  .failure(let receivedError as LocalPodcastsImageDataLoader.Error)):
                XCTAssertEqual(expectedError, receivedError, file: file, line: line)
                
            default:
                XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func failure(_ error: LocalPodcastsImageDataLoader.Error) -> Result<Data, Error> {
        return .failure(error)
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
        private(set) var requestCompletions: [(BestPodcastsStore.Result) -> Void] = []
        
        func retrieve(dataForURL url: URL, completion: @escaping (BestPodcastsStore.Result) -> Void) {
            receivedMessages.append(.retrieve(for: url))
            requestCompletions.append(completion)
        }
        
        func completeRetrieval(with error: Error, at index: Int = 0) {
            requestCompletions[index](.failure(error))
        }
        
        func completeRetrieval(with data: Data?, at index: Int = 0) {
            requestCompletions[index](.success(data))
        }
    }
}

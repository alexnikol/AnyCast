// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import BestPodcastsList

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
    
    func test_loadImageDataFromURL_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let store = StoreSpy()
        var sut: LocalPodcastsImageDataLoader? = LocalPodcastsImageDataLoader(store: store)
        
        var received = [ImageDataLoader.Result]()
        _ = sut?.loadImageData(from: anyURL()) { received.append($0) }
        
        sut = nil
        store.completeRetrieval(with: anyData())
        
        XCTAssertTrue(received.isEmpty, "Expected no received results after instance has been deallocated")
    }
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: LocalPodcastsImageDataLoader, store: StoreSpy) {
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
        private(set) var requestCompletions: [(BestPodcastsStore.RetrievalResult) -> Void] = []
        
        func retrieve(dataForURL url: URL, completion: @escaping (BestPodcastsStore.RetrievalResult) -> Void) {
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

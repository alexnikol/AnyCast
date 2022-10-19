// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import BestPodcastsList

protocol BestPodcastsStore {
    func retrieve(dataForURL url: URL)
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
        store.retrieve(dataForURL: url)
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
    
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) -> (sut: LocalPodcastsImageDataLoader, store: StoreSpy) {
        let store = StoreSpy()
        let sut = LocalPodcastsImageDataLoader(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func anyURL() -> URL {
        URL(string: "http://a-url.com")!
    }
    
    private class StoreSpy: BestPodcastsStore {
        enum Message: Equatable {
            case retrieve(for: URL)
        }
        
        private(set) var receivedMessages: [Message] = []
        
        func retrieve(dataForURL url: URL) {
            receivedMessages.append(.retrieve(for: url))
        }
    }
}

// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import PodcastsGenresList

class LocalGenresLoader {
    
    private let store: GenresStore
    private let currentDate: () -> Date
    
    init(store: GenresStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
        
    func save(_ items: [Genre], completion: @escaping (Error?) -> Void) {
        store.deleteCacheGenres { [unowned self] error in
            if error == nil {
                self.store.insert(items, timestamp: self.currentDate(), completion: completion)
            } else {
                completion(error)
            }
        }
    }
}

class GenresStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    
    enum ReceivedMessage: Equatable {
        case deleteCache
        case insert([Genre], Date)
        case insertFailure(NSError)
    }
    
    private(set) var receivedMessages: [ReceivedMessage] = []
    private var deletionCompletions: [DeletionCompletion] = []
    private var insertionCompletions: [InsertionCompletion] = []
    
    func deleteCacheGenres(completion: @escaping DeletionCompletion) {
        deletionCompletions.append(completion)
        receivedMessages.append(.deleteCache)
    }
    
    func completeDeletion(with error: NSError, at index: Int = 0) {
        deletionCompletions[index](error)
    }
    
    func completeDeletionSuccessfully(at index: Int = 0) {
        deletionCompletions[index](nil)
    }
    
    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionCompletions[index](error)
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionCompletions[index](nil)
    }
    
    func insert(_ items: [Genre], timestamp: Date, completion: @escaping InsertionCompletion) {
        insertionCompletions.append(completion)
        receivedMessages.append(.insert(items, timestamp))
    }
}

class CacheGenresUseCaseTests: XCTestCase {
    
    func test_init_doesNotMessageStoreCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_save_requestsCacheDeletion() {
        let (sut, store) = makeSUT()
        let items: [Genre] = [uniqueItem(id: 1), uniqueItem(id: 2)]
        
        sut.save(items) { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.deleteCache])
    }
    
    func test_save_doesNotRequestCacheInsertionOnDeletionError() {
        let (sut, store) = makeSUT()
        let items: [Genre] = [uniqueItem(id: 1), uniqueItem(id: 2)]
        let deletionError = anyNSError()
        
        sut.save(items) { _ in }
        store.completeDeletion(with: deletionError)
        
        XCTAssertEqual(store.receivedMessages, [.deleteCache])
    }
        
    func test_save_requestsNewCacheInsertionWithTimestampOnSuccessfulDeletion() {
        let timestamp = Date()
        let (sut, store) = makeSUT(currentDate: { timestamp })
        let items: [Genre] = [uniqueItem(id: 1), uniqueItem(id: 2)]
        
        sut.save(items) { _ in }
        store.completeDeletionSuccessfully()
        
        XCTAssertEqual(store.receivedMessages, [.deleteCache, .insert(items, timestamp)])
    }
    
    func test_save_failsOnDeletionError() {
        let (sut, store) = makeSUT()
        let items: [Genre] = [uniqueItem(id: 1), uniqueItem(id: 2)]
        let deletionError = anyNSError()
        let exp = expectation(description: "Wait for save completion")
        
        var receivedError: Error?
        sut.save(items) { error in
            receivedError = error
            
            exp.fulfill()
        }
        
        store.completeDeletion(with: deletionError)
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(receivedError as? NSError, deletionError)
    }
    
    func test_save_failsOnInsertionError() {
        let (sut, store) = makeSUT()
        let items: [Genre] = [uniqueItem(id: 1), uniqueItem(id: 2)]
        let insertionError = anyNSError()
        let exp = expectation(description: "Wait for save completion")
        
        var receivedError: Error?
        sut.save(items) { error in
            receivedError = error
            
            exp.fulfill()
        }
        
        store.completeDeletionSuccessfully()
        store.completeInsertion(with: insertionError)
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(receivedError as? NSError, insertionError)
    }
    
    func test_save_succeedsOnSuccessfulCacheInsertion() {
        let (sut, store) = makeSUT()
        let items: [Genre] = [uniqueItem(id: 1), uniqueItem(id: 2)]
        let exp = expectation(description: "Wait for save completion")
        
        var receivedError: Error?
        sut.save(items) { error in
            receivedError = error
            
            exp.fulfill()
        }
        
        store.completeDeletionSuccessfully()
        store.completeInsertionSuccessfully()
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertNil(receivedError)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        currentDate: @escaping () -> Date = Date.init,
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: LocalGenresLoader, store: GenresStore) {
        let store = GenresStore()
        let sut = LocalGenresLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func uniqueItem(id: Int) -> Genre {
        .init(id: id, name: "any genre")
    }
    
    private func anyNSError() -> NSError {
        NSError(domain: "any error", code: 0)
    }
}

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
        
    func save(_ items: [Genre]) {
        store.deleteCacheGenres { [unowned self] error in
            if error == nil {
                self.store.insert(items, timestamp: self.currentDate())
            }
        }
    }
}

class GenresStore {
    typealias DeletionCompletion = (Error?) -> Void
    
    enum ReceivedMessage: Equatable {
        case deleteCache
        case insert([Genre], Date)
    }
    
    private(set) var receivedMessages: [ReceivedMessage] = []
    private var deletionCompletion: [DeletionCompletion] = []
    
    func deleteCacheGenres(completion: @escaping DeletionCompletion) {
        deletionCompletion.append(completion)
        receivedMessages.append(.deleteCache)
    }
    
    func completeDeletion(with error: NSError, at index: Int = 0) {
        deletionCompletion[index](error)
    }
    
    func completeDeletionSuccessfully(at index: Int = 0) {
        deletionCompletion[index](nil)
    }
    
    func insert(_ items: [Genre], timestamp: Date) {
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
        
        sut.save(items)
        
        XCTAssertEqual(store.receivedMessages, [.deleteCache])
    }
    
    func test_save_doesNotRequestCacheInsertionOnDeletionError() {
        let (sut, store) = makeSUT()
        let items: [Genre] = [uniqueItem(id: 1), uniqueItem(id: 2)]
        let deletionError = anyNSError()
        
        sut.save(items)
        store.completeDeletion(with: deletionError)
        
        XCTAssertEqual(store.receivedMessages, [.deleteCache])
    }
        
    func test_save_requestsNewCacheInsertionWithTimestampOnSuccessfulDeletion() {
        let timestamp = Date()
        let (sut, store) = makeSUT(currentDate: { timestamp })
        let items: [Genre] = [uniqueItem(id: 1), uniqueItem(id: 2)]
        
        sut.save(items)
        store.completeDeletionSuccessfully()
        
        XCTAssertEqual(store.receivedMessages, [.deleteCache, .insert(items, timestamp)])
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

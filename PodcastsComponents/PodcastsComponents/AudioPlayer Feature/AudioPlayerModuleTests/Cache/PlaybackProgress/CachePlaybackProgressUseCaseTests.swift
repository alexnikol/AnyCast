// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import SharedTestHelpersLibrary
import AudioPlayerModule

final class CachePlaybackProgressUseCaseTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_save_requestsCacheDeletion() {
        let (sut, store) = makeSUT()
        let playingItem = makePlayingItemModels()
        
        sut.save(playingItem.model) { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.deleteCache])
    }
    
    func test_save_doesNotRequestCacheInsertionOnDeletionError() {
        let (sut, store) = makeSUT()
        let playingItem = makePlayingItemModels()
        let deletionError = anyNSError()
        
        sut.save(playingItem.model) { _ in }
        store.completeDeletion(with: deletionError)
        
        XCTAssertEqual(store.receivedMessages, [.deleteCache])
    }
    
    func test_save_requestsNewCacheInsertionWithTimestampOnSuccessfulDeletion() {
        let timestamp = Date()
        let (sut, store) = makeSUT(currentDate: { timestamp })
        let playingItem = makePlayingItemModels()
        
        sut.save(playingItem.model) { _ in }
        store.completeDeletionSuccessfully()
        
        XCTAssertEqual(store.receivedMessages, [.deleteCache, .insert(playingItem.localModel, timestamp)])
    }
    
    func test_save_failsOnDeletionError() {
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()
        
        expect(sut, toCompleteWithError: deletionError, when: {
            store.completeDeletion(with: deletionError)
        })
    }
    
    func test_save_failsOnInsertionError() {
        let (sut, store) = makeSUT()
        let insertionError = anyNSError()
        
        expect(sut, toCompleteWithError: insertionError, when: {
            store.completeDeletionSuccessfully()
            store.completeInsertion(with: insertionError)
        })
    }
    
    func test_save_succeedsOnSuccessfulCacheInsertion() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWithError: nil, when: {
            store.completeDeletionSuccessfully()
            store.completeInsertionSuccessfully()
        })
    }
    
    func test_save_doesNotDeliverDeletionErrorAfterSUTInstanceHasBeenDeallocated() {
        let store = PlaybackProgressStoreSpy()
        var sut: LocalPlaybackProgressLoader? = LocalPlaybackProgressLoader(store: store, currentDate: Date.init)
        let deletionError = anyNSError()
        
        var receivedResults = [LocalPlaybackProgressLoader.SaveResult]()
        sut?.save(makePlayingItemModels().model) { receivedResults.append($0) }
        
        sut = nil
        store.completeDeletion(with: deletionError)
        
        XCTAssertTrue(receivedResults.isEmpty)
    }
    
    func test_save_doesNotDeliverInsertionErrorAfterSUTInstanceHasBeenDeallocated() {
        let store = PlaybackProgressStoreSpy()
        var sut: LocalPlaybackProgressLoader? = LocalPlaybackProgressLoader(store: store, currentDate: Date.init)
        let insertionError = anyNSError()
        
        var receivedResults = [LocalPlaybackProgressLoader.SaveResult]()
        sut?.save(makePlayingItemModels().model) { receivedResults.append($0) }
        
        store.completeDeletionSuccessfully()
        sut = nil
        store.completeInsertion(with: insertionError)
        
        XCTAssertTrue(receivedResults.isEmpty)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        currentDate: @escaping () -> Date = Date.init,
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: LocalPlaybackProgressLoader, store: PlaybackProgressStoreSpy) {
        let store = PlaybackProgressStoreSpy()
        let sut = LocalPlaybackProgressLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func expect(
        _ sut: LocalPlaybackProgressLoader,
        toCompleteWithError expectedError: NSError?,
        when action: () -> Void,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let exp = expectation(description: "Wait for save completion")
        
        var receivedError: Error?
        sut.save(makePlayingItemModels().model) { error in
            receivedError = error
            
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(receivedError as? NSError, expectedError, file: file, line: line)
    }
}

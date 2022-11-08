// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import PodcastsModule

class CachePodcastImageDataUseCaseTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertTrue(store.receivedMessages.isEmpty)
    }
    
    func test_saveImageDataForURL_requestImageDataInsertionForURL() {
        let (sut, store) = makeSUT()
        let url = anyURL()
        let data = anyData()
        
        sut.save(data, for: url, completion: { _ in })
        
        XCTAssertEqual(store.receivedMessages, [.insert(data: data, for: url)])
    }
    
    func test_saveImageDataForURL_deliverErrorOnInertionError() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(LocalPodcastsImageDataLoader.SaveError.failed), when: {
            store.completeInsrertion(with: anyNSError())
        })
    }
    
    func test_saveImageDataForURL_deliverSuccessOnInsertionSuccess() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWith: .success(()), when: {
            store.completeInsrertionSuccessfully()
        })
    }
    
    func test_saveImageDataForURL_doesNotDeliverResultAfterSUTHasBeenDeallocated() {
        let store = PodcastsImageDataStoreSpy()
        var sut: LocalPodcastsImageDataLoader? = LocalPodcastsImageDataLoader(store: store, currentDate: Date.init)
        
        var receivedResult: [LocalPodcastsImageDataLoader.SaveResult] = []
        
        _ = sut?.save(anyData(), for: anyURL(), completion: { receivedResult.append($0) })
        
        sut = nil
        
        store.completeInsrertion(with: anyNSError())
        store.completeInsrertionSuccessfully()
        
        XCTAssertTrue(receivedResult.isEmpty, "Expected to be empty after sut has been deallocated")
    }
    
    // MARK: - Helpers
    
    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) -> (sut: LocalPodcastsImageDataLoader, store: PodcastsImageDataStoreSpy) {
        let store = PodcastsImageDataStoreSpy()
        let sut = LocalPodcastsImageDataLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func expect(
        _ sut: LocalPodcastsImageDataLoader,
        toCompleteWith expectedResult: LocalPodcastsImageDataLoader.SaveResult,
        when action: () -> Void,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let exp = expectation(description: "Wait for load completion")
        
        sut.save(anyData(), for: anyURL()) { receivedResult in
            switch (receivedResult, expectedResult) {
            case (.success, .success):
                break
                
            case (.failure(let receivedError as LocalPodcastsImageDataLoader.SaveError),
                  .failure(let expectedError as LocalPodcastsImageDataLoader.SaveError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                
            default:
                XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1.0)
    }
}

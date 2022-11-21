// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import PodcastsModule

class PlayingEpisodeService {
    enum LoadError: Error {
        case noPlayingEpisodeFound
        case retrievalError
    }
    
    typealias LoadResult = Swift.Result<Episode, Error>
    
    private let store: PlayingEpisodeStore
    
    init(store: PlayingEpisodeStore) {
        self.store = store
    }
    
    func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve(completion: { result in
            switch result {
            case .failure(let error):
                completion(.failure(LoadError.retrievalError))
                
            default: break
            }
        })
    }
}

class LocalEpisode {}

enum RetrieveCachePlayingEpisodeResult {
    case empty
    case found(genres: [LocalEpisode], timestamp: Date)
    case failure(Error)
}

protocol PlayingEpisodeStore {
    func retrieve(completion: @escaping (RetrieveCachePlayingEpisodeResult) -> Void)
}

class PlayingEpisodeServiceTests: XCTestCase {
    
    func test_init() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_load_requestsCacheRetrieval() {
        let (sut, store) = makeSUT()
        
        sut.load { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_deliversRetrivalErroronStoreRetrievalError() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(PlayingEpisodeService.LoadError.retrievalError), when: {
            store.completeRetrieval(with: anyNSError())
        })
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: PlayingEpisodeService, store: PlayingEpisodeStoreSpy) {
        let store = PlayingEpisodeStoreSpy()
        let sut = PlayingEpisodeService(store: store)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(store, file: file, line: line)
        return (sut, store)
    }
    
    private func expect(
        _ sut: PlayingEpisodeService,
        toCompleteWith expectedResult: PlayingEpisodeService.LoadResult,
        when action: () -> Void,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let exp = expectation(description: "Wait for load completion")
        
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedEpisode), .success(expectedEpisode)):
                XCTAssertEqual(receivedEpisode, expectedEpisode, file: file, line: line)
                
            case let (.failure(receivedError as PlayingEpisodeService.LoadError), .failure(expectedError as PlayingEpisodeService.LoadError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                
            case let (.failure(receivedError as NSError), .failure(expectedError  as NSError)):
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

private class PlayingEpisodeStoreSpy: PlayingEpisodeStore {
    enum Message: Equatable {
        case retrieve
    }
    
    private var retrievalCompletions: [(RetrieveCachePlayingEpisodeResult) -> Void] = []
    var receivedMessages: [Message] = []
    
    func retrieve(completion: @escaping (RetrieveCachePlayingEpisodeResult) -> Void) {
        retrievalCompletions.append(completion)
        receivedMessages.append(.retrieve)
    }
    
    func completeRetrieval(with error: Error, at index: Int = 0) {
        retrievalCompletions[index](.failure(error))
    }
}

func anyNSError() -> NSError {
    NSError(domain: "any error", code: 0)
}

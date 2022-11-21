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
        store.retrieve(completion: { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case .failure:
                completion(.failure(LoadError.retrievalError))
                
            case .empty:
                completion(.failure(LoadError.noPlayingEpisodeFound))
                
            case .found(let localEpisode):
                completion(.success(localEpisode.toModel()))
            }
        })
    }
}
                     
extension LocalEpisode {
    func toModel() -> Episode {
        let episode = Episode(
            id: self.id,
            title: self.title,
            description: self.description,
            thumbnail: self.thumbnail,
            audio: self.audio,
            audioLengthInSeconds: self.audioLengthInSeconds,
            containsExplicitContent: self.containsExplicitContent,
            publishDateInMiliseconds: self.publishDateInMiliseconds
        )
        return episode
    }
}

struct LocalEpisode: Equatable {
    let id: String
    let title: String
    let description: String
    let thumbnail: URL
    let audio: URL
    let audioLengthInSeconds: Int
    let containsExplicitContent: Bool
    let publishDateInMiliseconds: Int
    
    init(episode: Episode) {
        self.id = episode.id
        self.title = episode.title
        self.description = episode.description
        self.thumbnail = episode.thumbnail
        self.audio = episode.audio
        self.audioLengthInSeconds = episode.audioLengthInSeconds
        self.containsExplicitContent = episode.containsExplicitContent
        self.publishDateInMiliseconds = episode.publishDateInMiliseconds
    }
}

enum RetrieveCachePlayingEpisodeResult {
    case empty
    case found(episode: LocalEpisode)
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
    
    func test_load_deliversNoPlayingEpisodeOnEmptyCache() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(PlayingEpisodeService.LoadError.noPlayingEpisodeFound), when: {
            store.completeRetrievalWithEmptyCache()
        })
    }
    
    func test_load_deliversPlayingEpisodeOnNonEmptyCache() {
        let (sut, store) = makeSUT()
        let episode = makeUniqueEpisode()
        
        expect(sut, toCompleteWith: .success(episode.model), when: {
            store.completeRetrieval(with: episode.local)
        })
    }
    
    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let store = PlayingEpisodeStoreSpy()
        var sut: PlayingEpisodeService? = PlayingEpisodeService(store: store)
        
        var receivedResults: [PlayingEpisodeService.LoadResult] = []
        sut?.load { receivedResults.append($0) }
        
        sut = nil
        
        store.completeRetrievalWithEmptyCache()
        
        XCTAssertTrue(receivedResults.isEmpty)
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
    
    func anyNSError() -> NSError {
        NSError(domain: "any error", code: 0)
    }
    
    private func anyURL() -> URL {
        URL(string: "http://a-url.com")!
    }

    func makeUniqueEpisode(publishDate: Date = Date(), audioLengthInSeconds: Int = 100) -> (model: Episode, local: LocalEpisode) {
        let publishDateInMiliseconds = Int(publishDate.timeIntervalSince1970) * 1000
        let episode = Episode(
            id: UUID().uuidString,
            title: "Any Episode title",
            description: "<strong>Any Episode description</strong>",
            thumbnail: anyURL(),
            audio: anyURL(),
            audioLengthInSeconds: audioLengthInSeconds,
            containsExplicitContent: false,
            publishDateInMiliseconds: publishDateInMiliseconds
        )
        
        let localEpisode = LocalEpisode(episode: episode)
        return (episode, localEpisode)
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
    
    func completeRetrievalWithEmptyCache(at index: Int = 0) {
        retrievalCompletions[index](.empty)
    }
    
    func completeRetrieval(with result: LocalEpisode, at index: Int = 0) {
        retrievalCompletions[index](.found(episode: result))
    }
}

// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import SharedTestHelpersLibrary
import AudioPlayerModule

final class CoreDataPlaybackProgressStoreTests: XCTestCase {
    
    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = makeSUT()
        
        expect(sut, toRetrieve: .empty)
    }
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        
        expect(sut, toRetrieveTwice: .empty)
    }
    
    func test_retrieve_deliversFoundValuesOnNonEmptyCache() {
        let sut1 = makeSUT()
        
        let playingItem1 = makePlayingItemModel(with: [
            .volumeLevel(0.9),
            .progress(.init(currentTimeInSeconds: 200, totalTime: .notDefined, progressTimePercentage: 0.4)),
            .speed(.x1_25),
            .playback(.loading)
        ])
        
        let timestamp1 = Date()
        
        insert((playingItem1, timestamp1), to: sut1)
        
        expect(sut1, toRetrieve: .found(playingItem: playingItem1, timestamp: timestamp1))
        
        let sut2 = makeSUT()
        
        let playingItem2 = makePlayingItemModel(with: [
            .volumeLevel(0.1),
            .progress(.init(currentTimeInSeconds: 200, totalTime: .valueInSeconds(200), progressTimePercentage: 0.4)),
            .speed(.x2),
            .playback(.playing)
        ])
        
        let timestamp2 = Date()
        
        insert((playingItem2, timestamp2), to: sut2)
        
        expect(sut2, toRetrieve: .found(playingItem: playingItem2, timestamp: timestamp2))
    }
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {
        let sut = makeSUT()
        
        let playingItem = makePlayingItemModel(with: [
            .volumeLevel(0.9),
            .progress(.init(currentTimeInSeconds: 200, totalTime: .notDefined, progressTimePercentage: 0.4)),
            .speed(.x1_25),
            .playback(.loading)
        ])
        let timestamp = Date()
        
        insert((playingItem, timestamp), to: sut)
        
        expect(sut, toRetrieveTwice: .found(playingItem: playingItem, timestamp: timestamp))
    }
    
    func test_insert_deliversNoErrorOnEmptyCache() {
        let sut = makeSUT()
        
        let playingItem = makePlayingItemModel(with: [
            .volumeLevel(0.9),
            .progress(.init(currentTimeInSeconds: 200, totalTime: .notDefined, progressTimePercentage: 0.4)),
            .speed(.x1_25),
            .playback(.loading)
        ])
        
        let insertionError = insert((playingItem, Date()), to: sut)

        XCTAssertNil(insertionError, "Expected to insert cache successfully")
    }
    
    func test_insert_deliversNoErrorOnNonEmptyCache() {
        let sut = makeSUT()
        
        let playingItem = makePlayingItemModel(with: [
            .playback(.loading)
        ])
        
        insert((playingItem, Date()), to: sut)

        let playingIte2 = makePlayingItemModel(with: [
            .playback(.loading)
        ])
        
        let insertionError = insert((playingIte2, Date()), to: sut)

        XCTAssertNil(insertionError, "Expected to override cache successfully")
    }
    
    func test_insert_overridesPreviouslyInsertedCacheValues() {
        let sut = makeSUT()
        
        let playingItem = makePlayingItemModel(with: [
            .playback(.loading)
        ])
                
        insert((playingItem, Date()), to: sut)
        
        let latestPlayingItem = makePlayingItemModel(with: [
            .playback(.loading)
        ])
        let latestTimestamp = Date()
        insert((latestPlayingItem, latestTimestamp), to: sut)
        
        expect(sut, toRetrieve: .found(playingItem: latestPlayingItem, timestamp: latestTimestamp))
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> PlaybackProgressStore {
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let sut = try! CoreDataPlaybackProgressStore(storeURL: storeURL)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func expect(_ sut: PlaybackProgressStore,
                        toRetrieve expectedResult: RetrieveCachePlaybackProgressResult,
                        file: StaticString = #file,
                        line: UInt = #line) {
        let exp = expectation(description: "Wait for cache retrieval")
        
        sut.retrieve { retrievedResult in
            switch (expectedResult, retrievedResult) {
            case (.empty, .empty),
                (.failure, .failure):
                break
                
            case let (.found(expectedPlaybackProgress, expectedTimestamp), .found(retrievedPlaybackProgress, retrievedTimestamp)):
                XCTAssertEqual(expectedPlaybackProgress, retrievedPlaybackProgress, file: file, line: line)
                XCTAssertEqual(expectedTimestamp, retrievedTimestamp, "\(expectedTimestamp.timeIntervalSince1970) - \(retrievedTimestamp.timeIntervalSince1970)", file: file, line: line)
                
            default:
                XCTFail("Expected to retrieve \(expectedResult), got \(retrievedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private func expect(_ sut: PlaybackProgressStore,
                        toRetrieveTwice expectedResult: RetrieveCachePlaybackProgressResult,
                        file: StaticString = #file,
                        line: UInt = #line) {
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
    }
    
    @discardableResult
    func insert(_ cache: (playingItem: LocalPlayingItem, timestamp: Date),
                to sut: PlaybackProgressStore) -> Error? {
        var insertionError: Error?
        let exp = expectation(description: "Wait for cache insertion")
        sut.insert(cache.playingItem, timestamp: cache.timestamp) { receivedInsertionError in
            insertionError = receivedInsertionError
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        return insertionError
    }
    
    private func makePlayingItemModel(with updates: [LocalPlayingItem.State]) -> LocalPlayingItem {
        let episode = makeUniqueEpisode()
        let podcast = makePodcast()
        let localEpisode = LocalPlayingEpisode(
            id: episode.id,
            title: episode.title,
            thumbnail: episode.thumbnail,
            audio: episode.audio,
            publishDateInMiliseconds: episode.publishDateInMiliseconds
        )
        let localPodcast = LocalPlayingPodcast(id: podcast.id, title: podcast.title, publisher: podcast.publisher)
        let localModel = LocalPlayingItem(
            episode: localEpisode,
            podcast: localPodcast,
            updates: updates
        )
        return localModel
    }
}

// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import SharedTestHelpersLibrary
import AudioPlayerModule


final class CachePlaybackProgressUseCaseTests: XCTestCase {
    
    func test_init_doesNotMessageStoreCreation() {
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
    
    private func makePlayingItemModels() -> (model: PlayingItem, localModel: LocalPlayingItem) {
        let episode = makeUniqueEpisode()
        let podcast = makePodcast()
        let model = PlayingItem(
            episode: episode,
            podcast: podcast,
            updates: [
                .playback(.playing),
                .progress(
                    .init(
                        currentTimeInSeconds: 10,
                        totalTime: .notDefined,
                        progressTimePercentage: 0.1
                    )
                ),
                .volumeLevel(0.5)
            ]
        )
        
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
            updates: [
                .playback(.playing),
                .progress(
                    .init(
                        currentTimeInSeconds: 10,
                        totalTime: .notDefined,
                        progressTimePercentage: 0.1
                    )
                ),
                .volumeLevel(0.5)
            ]
        )
        
        return (model, localModel)
    }
}

private class PlaybackProgressStoreSpy: PlaybackProgressStore {
    enum Message: Equatable {
        case deleteCache
        case insert(LocalPlayingItem, Date)
    }
    
    private var deletionCompletions: [DeletionCompletion] = []
    private(set) var receivedMessages: [Message] = []
    
    func deleteCachedPlayingItem(completion: @escaping DeletionCompletion) {
        receivedMessages.append(.deleteCache)
        deletionCompletions.append(completion)
    }
    
    func completeDeletion(with error: NSError, at index: Int = 0) {
        deletionCompletions[index](error)
    }
    
    func completeDeletionSuccessfully(at index: Int = 0) {
        deletionCompletions[index](nil)
    }
    
    func insert(_ playingItem: LocalPlayingItem, timestamp: Date, completion: @escaping InsertionCompletion) {
        receivedMessages.append(.insert(playingItem, timestamp))
    }
}

// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import SharedTestHelpersLibrary
import AudioPlayerModule

class LocalPlayingItem {
    
}

final class LocalPlaybackProgressLoader {
    
    init(store: PlaybackProgressStore, currentDate: @escaping () -> Date) {}
}

protocol PlaybackProgressStore {
    
}

class PlaybackProgressStoreSpy: PlaybackProgressStore {
    enum Message {
        case deleteCache
    }
    
    private(set) var receivedMessages: [Message] = []
}

final class CachePlaybackProgressUseCaseTests: XCTestCase {
    
    func test_init_doesNotMessageStoreCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedMessages, [])
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
    
    private func makePlayingItem() -> PlayingItem {
        PlayingItem(
            episode: makeUniqueEpisode(),
            podcast: makePodcast(),
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
    }
}

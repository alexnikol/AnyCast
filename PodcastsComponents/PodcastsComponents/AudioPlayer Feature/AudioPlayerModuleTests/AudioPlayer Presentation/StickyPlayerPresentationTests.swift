// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import AudioPlayerModule
import PodcastsModule

struct StickyAudioPlayerViewModel {
    
}

protocol StickyAudioPlayerView {
    func display(viewModel: StickyAudioPlayerViewModel)
}

class StickyPlayerPresenter {
    private let resourceView: StickyAudioPlayerView
    
    init(resourceView: StickyAudioPlayerView) {
        self.resourceView = resourceView
    }
    
    func map(playingItem: PlayingItem) -> StickyAudioPlayerViewModel {
        StickyAudioPlayerViewModel()
    }
    
    func didReceivePlayerState(with playingItem: PlayingItem) {
        resourceView.display(viewModel: map(playingItem: playingItem))
    }
}

class StickyPlayerPresentationTests: XCTestCase {
    
    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    func test_didReceiveNewPlayerState_displaysNewPlayerState() {
        let (sut, view) = makeSUT()
        
        let playingItem = makePlayingItem(playbackState: .pause, currentTimeInSeconds: 0, totalTime: .notDefined, playbackSpeed: .x0_75)
        sut.didReceivePlayerState(with: playingItem)
        
        XCTAssertEqual(view.messages, [.update])
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: StickyPlayerPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let presenter = StickyPlayerPresenter(resourceView: view)
        trackForMemoryLeaks(presenter)
        trackForMemoryLeaks(view)
        return (presenter, view)
    }
    
    private class ViewSpy: StickyAudioPlayerView {
        enum Message {
            case update
        }
        private(set) var messages: [Message] = []
        
        func display(viewModel: StickyAudioPlayerViewModel) {
            messages.append(.update)
        }
    }
    
    private func makePlayingItem(
        playbackState: PlayingItem.PlaybackState,
        currentTimeInSeconds: Int,
        totalTime: EpisodeDuration,
        playbackSpeed: PlaybackSpeed
    ) -> PlayingItem {
        PlayingItem(
            episode: makeUniqueEpisode(),
            podcast: makePodcast(),
            updates: [
                .playback(playbackState),
                .progress(
                    .init(
                        currentTimeInSeconds: currentTimeInSeconds,
                        totalTime: totalTime,
                        progressTimePercentage: 0.1234
                    )
                ),
                .volumeLevel(0.5),
                .speed(playbackSpeed)
            ]
        )
    }
}

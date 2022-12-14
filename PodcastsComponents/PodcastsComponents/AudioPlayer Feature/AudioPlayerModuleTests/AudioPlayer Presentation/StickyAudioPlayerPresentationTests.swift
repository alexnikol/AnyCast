// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import SharedTestHelpersLibrary
import AudioPlayerModule
import PodcastsModule

class StickyAudioPlayerPresentationTests: XCTestCase {
    
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
    
    func test_createsViewModel() {
        let playingItem = makePlayingItem(playbackState: .pause, currentTimeInSeconds: 0, totalTime: .notDefined, playbackSpeed: .x1)
        
        let (sut, _) = makeSUT()
        let viewModel = sut.map(playingItem: playingItem)
        
        XCTAssertEqual(viewModel.titleLabel, "Any Episode title")
        XCTAssertEqual(viewModel.descriptionLabel, "Dec 13, 2022")
        XCTAssertEqual(viewModel.thumbnailURL, playingItem.episode.thumbnail)
        XCTAssertEqual(viewModel.playbackViewModel, PlaybackStateViewModel(playbackState: .pause))
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: StickyAudioPlayerPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let calendar = Calendar(identifier: .gregorian)
        let locale = Locale(identifier: "en_US_POSIX")
        let presenter = StickyAudioPlayerPresenter(resourceView: view, calendar: calendar, locale: locale)
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
}

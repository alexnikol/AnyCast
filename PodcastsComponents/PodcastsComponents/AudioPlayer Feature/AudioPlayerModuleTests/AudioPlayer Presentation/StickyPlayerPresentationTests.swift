// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import AudioPlayerModule
import PodcastsModule

struct StickyAudioPlayerViewModel {
    let titleLabel: String
    let descriptionLabel: String
    let thumbnailURL: URL
    
    init(
        titleLabel: String,
        descriptionLabel: String,
        thumbnailURL: URL
    ) {
        self.titleLabel = titleLabel
        self.descriptionLabel = descriptionLabel
        self.thumbnailURL = thumbnailURL
    }
}

protocol StickyAudioPlayerView {
    func display(viewModel: StickyAudioPlayerViewModel)
}

class StickyPlayerPresenter {
    private let resourceView: StickyAudioPlayerView
    private let calendar: Calendar
    private let locale: Locale
    
    init(resourceView: StickyAudioPlayerView, calendar: Calendar = .current, locale: Locale = .current) {
        self.resourceView = resourceView
        self.calendar = calendar
        self.locale = locale
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        var newCalendar = calendar
        newCalendar.locale = locale
        formatter.calendar = newCalendar
        return formatter
    }()
    
    func map(playingItem: PlayingItem) -> StickyAudioPlayerViewModel {
        let publishDate = Date(timeIntervalSince1970: TimeInterval(playingItem.episode.publishDateInMiliseconds / 1000))
        let displayPublishDate = dateFormatter.string(from: publishDate)
        return StickyAudioPlayerViewModel(
            titleLabel: playingItem.episode.title,
            descriptionLabel: displayPublishDate,
            thumbnailURL: playingItem.episode.thumbnail
        )
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
    
    func test_createsViewModel() {
        let playingItem = makePlayingItem(playbackState: .pause, currentTimeInSeconds: 0, totalTime: .notDefined, playbackSpeed: .x1)
        
        let (sut, _) = makeSUT()
        let viewModel = sut.map(playingItem: playingItem)
        
        XCTAssertEqual(viewModel.titleLabel, "Any Episode title")
        XCTAssertEqual(viewModel.descriptionLabel, "12 Dec 2022")
        XCTAssertEqual(viewModel.thumbnailURL, playingItem.episode.thumbnail)
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
}

// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import AudioPlayerModule
import PodcastsModule

class LargeAudioPlayerPresenterTests: XCTestCase {
    
    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    func test_didReceiveNewPlayerState_displaysNewPlayerState() {
        let (sut, view) = makeSUT()
        
        let playingItem = makePlayingItem(playbackState: .pause, currentTimeInSeconds: 0, totalTime: .notDefined)
        sut.didReceivePlayerState(with: playingItem)
        
        XCTAssertEqual(view.messages, [.udaptePlayerState])
    }
    
    func test_createsViewModel() {
        let playingItem = makePlayingItem(playbackState: .pause, currentTimeInSeconds: 0, totalTime: .notDefined)
        
        let (sut, _) = makeSUT()
        let viewModel = sut.map(playingItem: playingItem)
        
        XCTAssertEqual(viewModel.titleLabel, "Any Episode title")
        XCTAssertEqual(viewModel.descriptionLabel, "Any Podcast Title | Any Publisher Title")
        XCTAssertEqual(viewModel.updates.count, 3, "Should have 3 state update objects")
        
        for update in viewModel.updates {
            switch update {
            case let .progress(progressViewModel):
                XCTAssertEqual(progressViewModel.progressTimePercentage, 0.12)
                XCTAssertEqual(progressViewModel.currentTimeLabel, "0:00")
                XCTAssertEqual(progressViewModel.endTimeLabel, "...")
                
            case let .volumeLevel(volumeViewModel):
                XCTAssertEqual(volumeViewModel, 0.5)
                
            case let .playback(playbackViewModel):
                XCTAssertEqual(playbackViewModel, .pause)
            }
        }
    }
    
    func test_timesViewModelConvertations() {
        expect(
            makeSUT().sut,
            with: (currentTimeInSeconds: 0, totalTime: .notDefined),
            expectedTime: (currentTime: "0:00", totalTime: "...")
        )
        
        expect(
            makeSUT().sut,
            with: (currentTimeInSeconds: 59, totalTime: .valueInSeconds(60)),
            expectedTime: (currentTime: "0:59", totalTime: "1:00")
        )
        
        expect(
            makeSUT().sut,
            with: (currentTimeInSeconds: 60, totalTime: .valueInSeconds(121)),
            expectedTime: (currentTime: "1:00", totalTime: "2:01")
        )
        
        expect(
            makeSUT().sut,
            with: (currentTimeInSeconds: 121, totalTime: .valueInSeconds(454545)),
            expectedTime: (currentTime: "2:01", totalTime: "126:15:45")
        )
        
        expect(
            makeSUT().sut,
            with: (currentTimeInSeconds: 3599, totalTime: .notDefined),
            expectedTime: (currentTime: "59:59", totalTime: "...")
        )
        
        expect(
            makeSUT().sut,
            with: (currentTimeInSeconds: 3600, totalTime: .notDefined),
            expectedTime: (currentTime: "1:00:00", totalTime: "...")
        )
        
        expect(
            makeSUT().sut,
            with: (currentTimeInSeconds: 7199, totalTime: .notDefined),
            expectedTime: (currentTime: "1:59:59", totalTime: "...")
        )
        
        expect(
            makeSUT().sut,
            with: (currentTimeInSeconds: 7204, totalTime: .notDefined),
            expectedTime: (currentTime: "2:00:04", totalTime: "...")
        )
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: LargeAudioPlayerPresenter, view: ViewSpy) {
        let calendar = Calendar(identifier: .gregorian)
        let locale = Locale(identifier: "en_US_POSIX")
        let view = ViewSpy()
        let presenter = LargeAudioPlayerPresenter(resourceView: view, calendar: calendar, locale: locale)
        trackForMemoryLeaks(presenter)
        trackForMemoryLeaks(view)
        return (presenter, view)
    }
    
    private func expect(
        _ sut: LargeAudioPlayerPresenter,
        with model: (currentTimeInSeconds: Int, totalTime: EpisodeDuration),
        expectedTime: (currentTime: String, totalTime: String),
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let viewModel = sut.map(
            playingItem: makePlayingItem(
                playbackState: .pause,
                currentTimeInSeconds: model.currentTimeInSeconds,
                totalTime: model.totalTime
            )
        )
        
        var isProgressUpdateFoundInList = false
        for update in viewModel.updates {
            switch update {
            case let .progress(progressViewModel):
                isProgressUpdateFoundInList = true
                XCTAssertEqual(progressViewModel.currentTimeLabel, expectedTime.currentTime, file: file, line: line)
                XCTAssertEqual(progressViewModel.endTimeLabel, expectedTime.totalTime, file: file, line: line)
            
            default: break
            }
        }
        
        if !isProgressUpdateFoundInList {
            XCTFail("Update state not found in updates list")
        }
    }
    
    private func makePlayingItem(playbackState: PlayingItem.PlaybackState, currentTimeInSeconds: Int, totalTime: EpisodeDuration) -> PlayingItem {
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
                .volumeLevel(0.5)
            ]
        )
    }
        
    private class ViewSpy: AudioPlayerView {
        enum Message {
            case udaptePlayerState
        }
        private(set) var messages: [Message] = []
        
        func display(viewModel: LargeAudioPlayerViewModel) {
            messages.append(.udaptePlayerState)
        }
    }
}

public protocol AudioPlayerStateInput {
    func didPlay()
    func didPause()
}

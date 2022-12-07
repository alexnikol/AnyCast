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
        
        let playingItem = makePlayingItem(playbackState: .pause, currentTimeInSeconds: 0, totalTime: .notDefined, playbackSpeed: .x0_75)
        sut.didReceivePlayerState(with: playingItem)
        
        XCTAssertEqual(view.messages, [.udaptePlayerState])
    }
    
    func test_didReceiveSelectSpeedPlayback_displaysSelectSpeedPlaybackFlow() {
        let (sut, view) = makeSUT(fullListOfPlaybackSpeed: [.x1, .x1_25])
        
        sut.onSelectSpeedPlayback()
        
        XCTAssertEqual(view.messages, [.displaySpeedSelection])
    }
    
    func test_createsViewModel() {
        let playingItem = makePlayingItem(playbackState: .pause, currentTimeInSeconds: 0, totalTime: .notDefined, playbackSpeed: .x1)
        
        let (sut, _) = makeSUT()
        let viewModel = sut.map(playingItem: playingItem)
        
        XCTAssertEqual(viewModel.titleLabel, "Any Episode title")
        XCTAssertEqual(viewModel.descriptionLabel, "Any Podcast Title | Any Publisher Title")
        XCTAssertEqual(viewModel.updates.count, 4, "Should have 4 state update objects")
        
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
                
            default: break
            }
        }
    }
    
    func test_speedPlayback_viewModelConvertations() {
        let (sut, _) = makeSUT(fullListOfPlaybackSpeed: [.x0_75, .x2])
        expectSpeedConverations(
            sut,
            withSelected: .x2,
            expectedViewModel: SpeedPlaybackItemViewModel(displayTitle: "2x", isSelected: true)
        )
        
        let (sut2, _) = makeSUT(fullListOfPlaybackSpeed: PlaybackSpeed.allCases)
        expectSpeedConverations(
            sut2,
            withSelected: .x1,
            expectedViewModel: SpeedPlaybackItemViewModel(displayTitle: "1x", isSelected: true)
        )
    }
    
    func test_time_viewModelConvertations() {
        expectTimeConvertations(
            makeSUT().sut,
            with: (currentTimeInSeconds: 0, totalTime: .notDefined),
            expectedTime: (currentTime: "0:00", totalTime: "...")
        )
        
        expectTimeConvertations(
            makeSUT().sut,
            with: (currentTimeInSeconds: 59, totalTime: .valueInSeconds(60)),
            expectedTime: (currentTime: "0:59", totalTime: "1:00")
        )
        
        expectTimeConvertations(
            makeSUT().sut,
            with: (currentTimeInSeconds: 60, totalTime: .valueInSeconds(121)),
            expectedTime: (currentTime: "1:00", totalTime: "2:01")
        )
        
        expectTimeConvertations(
            makeSUT().sut,
            with: (currentTimeInSeconds: 121, totalTime: .valueInSeconds(454545)),
            expectedTime: (currentTime: "2:01", totalTime: "126:15:45")
        )
        
        expectTimeConvertations(
            makeSUT().sut,
            with: (currentTimeInSeconds: 3599, totalTime: .notDefined),
            expectedTime: (currentTime: "59:59", totalTime: "...")
        )
        
        expectTimeConvertations(
            makeSUT().sut,
            with: (currentTimeInSeconds: 3600, totalTime: .notDefined),
            expectedTime: (currentTime: "1:00:00", totalTime: "...")
        )
        
        expectTimeConvertations(
            makeSUT().sut,
            with: (currentTimeInSeconds: 7199, totalTime: .notDefined),
            expectedTime: (currentTime: "1:59:59", totalTime: "...")
        )
        
        expectTimeConvertations(
            makeSUT().sut,
            with: (currentTimeInSeconds: 7204, totalTime: .notDefined),
            expectedTime: (currentTime: "2:00:04", totalTime: "...")
        )
    }
    
    // MARK: - Helpers
    
    private func makeSUT(fullListOfPlaybackSpeed: [PlaybackSpeed] = PlaybackSpeed.allCases) -> (sut: LargeAudioPlayerPresenter, view: ViewSpy) {
        let calendar = Calendar(identifier: .gregorian)
        let locale = Locale(identifier: "en_US_POSIX")
        let view = ViewSpy()
        let presenter = LargeAudioPlayerPresenter(resourceView: view, calendar: calendar, locale: locale, playbackSpeedList: fullListOfPlaybackSpeed)
        trackForMemoryLeaks(presenter)
        trackForMemoryLeaks(view)
        return (presenter, view)
    }
    
    private func expectTimeConvertations(
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
                totalTime: model.totalTime,
                playbackSpeed: .x0_75
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
    
    private func expectSpeedConverations(
        _ sut: LargeAudioPlayerPresenter,
        withSelected model: PlaybackSpeed,
        expectedViewModel: SpeedPlaybackItemViewModel,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let viewModel = sut.map(
            playingItem: makePlayingItem(
                playbackState: .pause,
                currentTimeInSeconds: 0,
                totalTime: .valueInSeconds(3),
                playbackSpeed: model
            )
        )
        
        var isUpdateFoundInList = false
        for update in viewModel.updates {
            switch update {
            case let .speed(receivedViewModel):
                isUpdateFoundInList = true
                XCTAssertEqual(receivedViewModel, expectedViewModel, file: file, line: line)
            
            default: break
            }
        }
        
        if !isUpdateFoundInList {
            XCTFail("Update state not found in updates list")
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
        
    private class ViewSpy: AudioPlayerView {
        enum Message {
            case udaptePlayerState
            case displaySpeedSelection
        }
        private(set) var messages: [Message] = []
        
        func display(viewModel: LargeAudioPlayerViewModel) {
            messages.append(.udaptePlayerState)
        }
        
        func displaySpeedPlaybackSelection(viewModel: AudioPlayerModule.SpeedPlaybackViewModel) {
            messages.append(.displaySpeedSelection)
        }
    }
}

public protocol AudioPlayerStateInput {
    func didPlay()
    func didPause()
}

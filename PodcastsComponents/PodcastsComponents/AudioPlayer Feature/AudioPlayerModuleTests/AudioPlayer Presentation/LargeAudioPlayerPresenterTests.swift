// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import AudioPlayerModule
import PodcastsModule

class LargeAudioPlayerPresenterTests: XCTestCase {
    
    func test_createsViewModel() {
        let podcast = makePodcast(title: "Any Podcast title", publisher: "Any Publisher name")
        let playingItem = makePlayingItem(playbackState: .pause, currentTimeInSeconds: 0, totalTime: .notDefined)
        
        let viewModel = makeSUT().map(playingItem: playingItem, from: podcast)
        
        XCTAssertEqual(viewModel.titleLabel, "Any Episode title")
        XCTAssertEqual(viewModel.descriptionLabel, "Any Podcast title | Any Publisher name")
        XCTAssertEqual(viewModel.volumeLevel, 0.5)
        XCTAssertEqual(viewModel.progressTimePercentage, 0.12)
        XCTAssertEqual(viewModel.playbackState, .pause)
    }
    
    func test_timesViewModelConvertations() {
        expect(
            makeSUT(),
            with: (currentTimeInSeconds: 0, totalTime: .notDefined),
            expectedTime: (currentTime: "0:00", totalTime: "...")
        )
        
        expect(
            makeSUT(),
            with: (currentTimeInSeconds: 59, totalTime: .valueInSeconds(60)),
            expectedTime: (currentTime: "0:59", totalTime: "1:00")
        )
        
        expect(
            makeSUT(),
            with: (currentTimeInSeconds: 60, totalTime: .valueInSeconds(121)),
            expectedTime: (currentTime: "1:00", totalTime: "2:01")
        )
        
        expect(
            makeSUT(),
            with: (currentTimeInSeconds: 121, totalTime: .valueInSeconds(454545)),
            expectedTime: (currentTime: "2:01", totalTime: "126:15:45")
        )
        
        expect(
            makeSUT(),
            with: (currentTimeInSeconds: 3599, totalTime: .notDefined),
            expectedTime: (currentTime: "59:59", totalTime: "...")
        )
        
        expect(
            makeSUT(),
            with: (currentTimeInSeconds: 3600, totalTime: .notDefined),
            expectedTime: (currentTime: "1:00:00", totalTime: "...")
        )
        
        expect(
            makeSUT(),
            with: (currentTimeInSeconds: 7199, totalTime: .notDefined),
            expectedTime: (currentTime: "1:59:59", totalTime: "...")
        )
        
        expect(
            makeSUT(),
            with: (currentTimeInSeconds: 7204, totalTime: .notDefined),
            expectedTime: (currentTime: "2:00:04", totalTime: "...")
        )
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> LargeAudioPlayerPresenter {
        let calendar = Calendar(identifier: .gregorian)
        let locale = Locale(identifier: "en_US_POSIX")
        let presenter = LargeAudioPlayerPresenter(calendar: calendar, locale: locale)
        trackForMemoryLeaks(presenter)
        return presenter
    }
    
    private func expect(
        _ sut: LargeAudioPlayerPresenter,
        with model: (currentTimeInSeconds: Int, totalTime: EpisodeDuration),
        expectedTime: (currentTime: String, totalTime: String),
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let podcast = makePodcast(title: "Any Podcast title", publisher: "Any Publisher name")
        let viewModel = sut.map(
            playingItem: makePlayingItem(
                playbackState: .pause,
                currentTimeInSeconds: model.currentTimeInSeconds,
                totalTime: model.totalTime
            ),
            from: podcast
        )
        XCTAssertEqual(viewModel.currentTimeLabel, expectedTime.currentTime, file: file, line: line)
        XCTAssertEqual(viewModel.endTimeLabel, expectedTime.totalTime, file: file, line: line)
    }
    
    private func makePlayingItem(playbackState: PlayingItem.PlaybackState, currentTimeInSeconds: Int, totalTime: EpisodeDuration) -> PlayingItem {
        let playingEpisode = makeUniqueEpisode()
        let playingState = PlayingItem.State(
            playbackState: playbackState,
            currentTimeInSeconds: currentTimeInSeconds,
            totalTime: totalTime,
            progressTimePercentage: 0.1234,
            volumeLevel: 0.5
        )
        return PlayingItem(episode: playingEpisode, state: playingState)
    }
    
    private func makePodcast(title: String, publisher: String) -> Podcast {
        Podcast(id: UUID().uuidString, title: title, publisher: publisher, language: "Any language", type: .episodic, image: anyURL())
    }
}

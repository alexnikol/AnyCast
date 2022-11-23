// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import AudioPlayerModule
import PodcastsModule

enum PlaybackStateViewModel {
    case playing
    case pause
    case loading
    
    init(playbackState: PlayingItem.PlaybackState) {
        switch playbackState {
        case .playing:
            self = .playing
            
        case .pause:
            self = .pause
            
        case .loading:
            self = .loading
        }
    }
}

struct LargeAudioPlayerViewModel {
    let titleLabel: String
    let descriptionLabel: String
    let currentTimeLabel: String
    let endTimeLabel: String
    let progressTimePercentage: Double
    let volumeLevel: Double
    let playbackState: PlaybackStateViewModel
}

class LargeAudioPlayerPresenter {
    private let calendar: Calendar
    private let locale: Locale
    
    init(calendar: Calendar = .current, locale: Locale = .current) {
        self.calendar = calendar
        self.locale = locale
    }
    
    func map(playingItem: PlayingItem, from podcast: Podcast) -> LargeAudioPlayerViewModel {
        let description = "\(podcast.title) | \(podcast.publisher)"
        return LargeAudioPlayerViewModel(
            titleLabel: playingItem.episode.title,
            descriptionLabel: description,
            currentTimeLabel: mapCurrentTimeLabel(playingItem.state.currentTimeInSeconds),
            endTimeLabel: mapEndTimeLabel(playingItem.state.totalTime),
            progressTimePercentage: playingItem.state.progressTimePercentage.roundToDecimal(2),
            volumeLevel: playingItem.state.volumeLevel,
            playbackState: PlaybackStateViewModel(playbackState: playingItem.state.playbackState)
        )
    }
    
    private func mapCurrentTimeLabel(_ timeInSeconds: Int) -> String {
        return "0:00"
    }
    
    private func mapEndTimeLabel(_ duration: EpisodeDuration) -> String {
        switch duration {
        case .notDefined:
            return "..."
        case .valueInSeconds:
            return "ddd"
        }
    }
}

extension Double {
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}

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
    
    // MARK: - Helpers
    
    private func makeSUT() -> LargeAudioPlayerPresenter {
        let calendar = Calendar(identifier: .gregorian)
        let locale = Locale(identifier: "en_US_POSIX")
        let presenter = LargeAudioPlayerPresenter(calendar: calendar, locale: locale)
        trackForMemoryLeaks(presenter)
        return presenter
    }
    
    private func makePlayingItem(playbackState: PlayingItem.PlaybackState, currentTimeInSeconds: Int, totalTime: EpisodeDuration) -> PlayingItem {
        let playingEpisode = makeUniqueEpisode()
        let playingState = PlayingItem.State(
            playbackState: .pause,
            currentTimeInSeconds: 0,
            totalTime: .notDefined,
            progressTimePercentage: 0.1234,
            volumeLevel: 0.5
        )
        return PlayingItem(episode: playingEpisode, state: playingState)
    }
    
    private func makePodcast(title: String, publisher: String) -> Podcast {
        Podcast(id: UUID().uuidString, title: title, publisher: publisher, language: "Any language", type: .episodic, image: anyURL())
    }
}

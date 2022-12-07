// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import UIKit
import PodcastsModule
import AudioPlayerModule
import AudioPlayerModuleiOS

class AudioPlayerModuleiOSTests: XCTestCase {
    
    func test_playerPortrait() {
        let sut = makeSUT()
        sut.loadViewIfNeeded()
        
        sut.display(viewModel: makeViewModel())
        
        assert(snapshot: sut.snapshot(for: .iPhone14(style: .light)), named: "LARGE_PLAYER_WITH_PAUSED_ITEM_PORTRAIT_light")
        assert(snapshot: sut.snapshot(for: .iPhone14(style: .dark)), named: "LARGE_PLAYER_WITH_PAUSED_ITEM_PORTRAIT_dark")
    }
    
    func test_playerLandscape() {
        let sut = makeSUT()
        sut.view.frame = CGRect(origin: .zero, size: SnapshotConfiguration.Orientation.landscape.size)
        sut.loadViewIfNeeded()
        sut.viewDidLayoutSubviews()
        
        sut.display(viewModel: makeViewModel())
        
        assert(snapshot: sut.snapshot(for: .iPhone14(style: .light, orientation: .landscape)), named: "LARGE_PLAYER_WITH_PAUSED_ITEM_LANDSCAPE_light")
        assert(snapshot: sut.snapshot(for: .iPhone14(style: .dark, orientation: .landscape)), named: "LARGE_PLAYER_WITH_PAUSED_ITEM_LANDSCAPE_dark")
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> LargeAudioPlayerViewController {
        let sut = LargeAudioPlayerViewController(
            delegate: LargeAudioPlayerViewDelegateNullObject(),
            controlsDelegate: AudioPlayerControlsDelegateNullObject()
        )
        return sut
    }
    
    func makeViewModel() -> LargeAudioPlayerViewModel {
        let plaingItem = PlayingItem(
            episode: makeEpisode(),
            podcast: makePodcast(),
            updates: [
                .playback(.pause),
                .progress(
                    .init(
                        currentTimeInSeconds: 0,
                        totalTime: .valueInSeconds(123123123),
                        progressTimePercentage: 0)
                ),
                .volumeLevel(0.5)
            ]
        )
        let calendar = Calendar(identifier: .gregorian)
        let locale = Locale(identifier: "en_US_POSIX")
        let presenter = LargeAudioPlayerPresenter(resourceView: NullObject(), calendar: calendar, locale: locale)
        
        return presenter.map(playingItem: plaingItem)
    }
    
    private func makeEpisode() -> Episode {
        Episode(
            id: UUID().uuidString,
            title: "Any Episode Title".repeatTimes(10),
            description: "Any Episode Description".repeatTimes(10),
            thumbnail: anyURL(),
            audio: anyURL(),
            audioLengthInSeconds: Int.random(in: 1...1000),
            containsExplicitContent: Bool.random(),
            publishDateInMiliseconds: Int.random(in: 1479110301853...1479110401853)
        )
    }
    
    private func makePodcast() -> PodcastDetails {
        PodcastDetails(
            id: UUID().uuidString,
            title: "Any Podcast Title",
            publisher: "Any Publisher Title",
            language: "Any language",
            type: .episodic,
            image: anyURL(),
            episodes: [],
            description: "Any description",
            totalEpisodes: 100
        )
    }
    
    private func anyURL() -> URL {
        URL(string: "http://a-url.com")!
    }
    
    private class NullObject: AudioPlayerView {
        func display(viewModel: LargeAudioPlayerViewModel) {}
    }
    
    private class LargeAudioPlayerViewDelegateNullObject: LargeAudioPlayerViewDelegate {
        func onOpen() {}
        func onClose() {}
        func onSelectSpeedPlayback() {}
    }
    
    private class AudioPlayerControlsDelegateNullObject: AudioPlayerControlsDelegate {
        var isPlaying = false
        func pause() {}
        func play() {}
        func changeVolumeTo(value: Float) {}
        func seekToProgress(_ progress: Float) {}
        func seekToSeconds(_ seconds: Int) {}
    }
}

private extension String {
    func repeatTimes(_ times: Int) -> String {
        return String(repeating: self + " ", count: times)
    }
}

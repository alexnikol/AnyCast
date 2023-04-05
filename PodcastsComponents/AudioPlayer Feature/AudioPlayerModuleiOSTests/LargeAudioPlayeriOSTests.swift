// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import SharedTestHelpersLibrary
import UIKit
import AudioPlayerModule
import AudioPlayerModuleiOS
import SharedComponentsiOSModule

final class LargeAudioPlayeriOSTests: XCTestCase {
    
    func test_playerPortrait() {
        let sut = makeSUT()
        sut.loadViewIfNeeded()
        
        sut.display(viewModel: makeViewModel())
        
        assert(snapshot: sut.snapshot(for: .iPhone14(style: .light)), named: "LARGE_PLAYER_WITH_PAUSED_ITEM_PORTRAIT_light")
        assert(snapshot: sut.snapshot(for: .iPhone14(style: .dark)), named: "LARGE_PLAYER_WITH_PAUSED_ITEM_PORTRAIT_dark")
    }
    
    func test_playerLandscape() {
        let sut = makeSUT()
        sut.updateFrameWith(orientation: .landscape)
        sut.loadViewIfNeeded()
        
        sut.display(viewModel: makeViewModel())
        
        assert(snapshot: sut.snapshot(for: .iPhone14(style: .light, orientation: .landscape)), named: "LARGE_PLAYER_WITH_PAUSED_ITEM_LANDSCAPE_light")
        assert(snapshot: sut.snapshot(for: .iPhone14(style: .dark, orientation: .landscape)), named: "LARGE_PLAYER_WITH_PAUSED_ITEM_LANDSCAPE_dark")
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> LargeAudioPlayerViewController {
        let sut = LargeAudioPlayerViewController(
            delegate: LargeAudioPlayerViewDelegateNullObject(),
            controlsDelegate: AudioPlayerControlsDelegateNullObject(),
            thumbnailViewController: ThumbnailDynamicViewController()
        )
        return sut
    }
    
    func makeViewModel() -> LargeAudioPlayerViewModel {
        let plaingItem = PlayingItem(
            episode: makePlayingEpisode(),
            podcast: makePlayingPodcast(),
            updates: [
                .playback(.pause),
                .progress(
                    .init(
                        currentTimeInSeconds: 0,
                        totalTime: .valueInSeconds(123123123),
                        progressTimePercentage: 0)
                ),
                .volumeLevel(0.5),
                .speed(.x1_25)
            ]
        )
        let calendar = Calendar(identifier: .gregorian)
        let locale = Locale(identifier: "en_US_POSIX")
        let presenter = LargeAudioPlayerPresenter(resourceView: DummyLargeAudioPlayerView(), calendar: calendar, locale: locale)
        
        return presenter.map(playingItem: plaingItem)
    }
        
    private class DummyLargeAudioPlayerView: LargeAudioPlayerView {
        func diplayFuturePrepareForSeekProgress(with progress: AudioPlayerModule.ProgressViewModel) {}
        func display(viewModel: LargeAudioPlayerViewModel) {}
        func displaySpeedPlaybackSelection(with list: [AudioPlayerModule.PlaybackSpeed]) {}
    }
    
    private class LargeAudioPlayerViewDelegateNullObject: LargeAudioPlayerViewDelegate {
        func onOpen() {}
        func onClose() {}
        func onSelectSpeedPlayback() {}
    }
}

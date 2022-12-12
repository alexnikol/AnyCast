// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import UIKit
import PodcastsModule
import AudioPlayerModule
import AudioPlayerModuleiOS
import SharedComponentsiOSModule

class StickyAudioPlayeriOSTests: XCTestCase {
    
    func test_player_portrait() {
        let (sut, root) = makeSUT()
        root.updateFrameWith(orientation: .portrait)
        sut.updateFrameWith(
            frame: CGRect(x: 0,
                          y: SnapshotConfiguration.Orientation.portrait.size.height - 60,
                          width: SnapshotConfiguration.Orientation.portrait.size.width,
                          height: 60)
        )
        
        sut.display(viewModel: makeViewModel(playback: .pause))
        
        assert(snapshot: root.snapshot(for: .iPhone14(style: .light)), named: "STICKY_PLAYER_WITH_PAUSED_ITEM_PORTRAIT_light")
        assert(snapshot: root.snapshot(for: .iPhone14(style: .dark)), named: "STICKY_PLAYER_WITH_PAUSED_ITEM_PORTRAIT_dark")
    }
    
    func test_player_landscape() {
        let (sut, root) = makeSUT()
        root.updateFrameWith(orientation: .landscape)
        sut.updateFrameWith(
            frame: CGRect(x: 0,
                          y: SnapshotConfiguration.Orientation.landscape.size.height - 60,
                          width: SnapshotConfiguration.Orientation.landscape.size.width,
                          height: 60)
        )
        
        sut.display(viewModel: makeViewModel(playback: .playing))
        
        assert(snapshot: root.snapshot(for: .iPhone14(style: .light, orientation: .landscape)), named: "STICKY_PLAYER_WITH_PAUSED_ITEM_LANDSCAPE_light")
        assert(snapshot: root.snapshot(for: .iPhone14(style: .dark, orientation: .landscape)), named: "STICKY_PLAYER_WITH_PAUSED_ITEM_LANDSCAPE_dark")
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: StickyAudioPlayerViewController, rootController: UIViewController) {
        let sut = StickyAudioPlayerViewController()
        let rootController = UIViewController()
        rootController.loadViewIfNeeded()
        rootController.view.backgroundColor = .gray
        rootController.addChild(sut)
        rootController.view.addSubview(sut.view)
        return (sut, rootController)
    }
    
    func makeViewModel(playback: PlayingItem.PlaybackState) -> StickyAudioPlayerViewModel {
        let plaingItem = PlayingItem(
            episode: makeEpisode(),
            podcast: makePodcast(),
            updates: [
                .playback(playback),
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
        let presenter = StickyAudioPlayerPresenter(resourceView: DummyStickyAudioPlayerView(), calendar: calendar, locale: locale)
        return presenter.map(playingItem: plaingItem)
    }
    
    private class DummyStickyAudioPlayerView: StickyAudioPlayerView {
        func display(viewModel: AudioPlayerModule.StickyAudioPlayerViewModel) {}
    }
}

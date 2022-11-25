// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import AudioPlayerModuleiOS

class AudioPlayerModuleiOSTests: XCTestCase {
    
    func test_pausedPlayerPortrait() {
        let sut = makeSUT()
        
        record(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "LARGE_PLAYER_WITH_PAUSED_ITEM_PORTRAIT_light")
        record(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "LARGE_PLAYER_WITH_PAUSED_ITEM_PORTRAIT_dark")
    }
    
    func test_pausedPlayerLandscape() {
        let sut = makeSUT()
        
        record(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "LARGE_PLAYER_WITH_PAUSED_ITEM_LANDSCAPE_light")
        record(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "LARGE_PLAYER_WITH_PAUSED_ITEM_LANDSCAPE_dark")
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> LargeAudioPlayerViewController {
        let controller = LargeAudioPlayerViewController(
            nibName: String(describing: LargeAudioPlayerViewController.self),
            bundle: Bundle(for: LargeAudioPlayerViewController.self)
        )
        return controller
    }
}

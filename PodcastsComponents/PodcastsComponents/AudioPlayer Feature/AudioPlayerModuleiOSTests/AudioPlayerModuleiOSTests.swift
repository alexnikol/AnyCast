// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import AudioPlayerModule
import AudioPlayerModuleiOS

class AudioPlayerModuleiOSTests: XCTestCase {
    
    func test_pausedPlayerPortrait() {
        let sut = makeSUT()
        
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "LARGE_PLAYER_WITH_PAUSED_ITEM_PORTRAIT_light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "LARGE_PLAYER_WITH_PAUSED_ITEM_PORTRAIT_dark")
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> LargeAudioPlayerViewController {
        LargeAudioPlayerViewController(
            delegate: LargeAudioPlayerViewDelegateNullObject(),
            controlsDelegate: AudioPlayerControlsDelegateNullObject()
        )
    }
    
    private class LargeAudioPlayerViewDelegateNullObject: LargeAudioPlayerViewLifetimeDelegate {
        func onOpen() {}
        func onClose() {}
    }
    
    private class AudioPlayerControlsDelegateNullObject: AudioPlayerControlsDelegate {
        func togglePlay() {}
        func onVolumeChange(value: Float) {}
        func onSeek(value: Float) {}
    }
}

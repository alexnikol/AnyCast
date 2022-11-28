// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest
import AudioPlayerModuleiOS

class AudioPlayerModuleiOSTests: XCTestCase {
    
    func test_pausedPlayerPortrait() {
        let sut = makeSUT()
        
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "LARGE_PLAYER_WITH_PAUSED_ITEM_PORTRAIT_light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "LARGE_PLAYER_WITH_PAUSED_ITEM_PORTRAIT_dark")
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> LargeAudioPlayerViewController {
        LargeAudioPlayerViewController(delegate: LargeAudioPlayerViewDelegateSpy())
    }
    
    private class LargeAudioPlayerViewDelegateSpy: LargeAudioPlayerViewLifetimeDelegate {
        func onOpen() {}
        
        func onClose() {}
    }
}

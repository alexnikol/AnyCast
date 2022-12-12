// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import AudioPlayerModuleiOS

extension StickyAudioPlayerViewController {
    
    func simulateUserInitiatedTogglePlaybackEpisode() {
        self.playToggleTap(self)
    }
    
    func simulateUserInitiatedSeekForeward() {
        self.goForewardTap(self)
    }
}

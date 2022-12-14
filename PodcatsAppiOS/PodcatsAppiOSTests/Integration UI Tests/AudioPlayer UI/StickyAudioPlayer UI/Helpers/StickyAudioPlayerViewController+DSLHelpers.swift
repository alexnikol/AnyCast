// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import AudioPlayerModuleiOS

extension StickyAudioPlayerViewController {
    
    func episodeTitleText() -> String? {
        return self.titleLabel.text
    }
    
    func episodeDescriptionText() -> String? {
        self.descriptionLabel.text
    }
    
    func simulateUserInitiatedTogglePlaybackEpisode() {
        self.playToggleTap(self)
    }
    
    func simulateUserInitiatedSeekForeward() {
        self.goForewardTap(self)
    }
    
    func playButtonImage() -> UIImage? {
        playButton.image(for: .normal)
    }
}

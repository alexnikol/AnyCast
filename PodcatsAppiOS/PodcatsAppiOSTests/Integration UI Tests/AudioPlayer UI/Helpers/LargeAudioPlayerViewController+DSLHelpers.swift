// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import AudioPlayerModuleiOS

extension LargeAudioPlayerViewController {
    
    func episodeTitleText() -> String? {
        return self.titleLabel.text
    }
    
    func episodeDescriptionText() -> String? {
        self.descriptionLabel.text
    }
    
    func simulateUserInitiatedTogglePlaybackEpisode() {
        self.playToggleTap(self)
    }
    
    func simulateUserInitiatedVolumeChange(to value: Float) {
        let slider = UISlider()
        slider.value = value
        self.volumeDidChange(slider)
    }
}

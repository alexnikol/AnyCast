// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import AudioPlayerModule
import AudioPlayerModuleiOS

class AudioPlayerViewAdapter {
    private weak var controller: LargeAudioPlayerViewController?
    
    init(controller: LargeAudioPlayerViewController) {
        self.controller = controller
    }
}

extension AudioPlayerViewAdapter: AudioPlayerView {
    
    func display(viewModel: LargeAudioPlayerViewModel) {
        controller?.titleLabel.text = viewModel.titleLabel
        controller?.descriptionLabel.text = viewModel.descriptionLabel
        controller?.leftTimeLabel.text = viewModel.currentTimeLabel
        controller?.rightTimeLabel.text = viewModel.endTimeLabel
        controller?.volumeView.value = viewModel.volumeLevel
        controller?.progressView.value = viewModel.progressTimePercentage
    }
}

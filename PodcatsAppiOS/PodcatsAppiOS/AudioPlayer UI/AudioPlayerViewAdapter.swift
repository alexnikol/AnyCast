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
        controller?.display(viewModel: viewModel)
    }
    
    func displaySpeedPlaybackSelection(viewModel: SpeedPlaybackViewModel) {
        
    }
}

// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import Combine
import AudioPlayerModule
import SharedComponentsiOSModule
import AudioPlayerModuleiOS

class StickyAudioPlayerViewAdapter {
    private weak var controller: StickyAudioPlayerViewController?
    
    init(controller: StickyAudioPlayerViewController) {
        self.controller = controller
    }
}

extension StickyAudioPlayerViewAdapter: StickyAudioPlayerView {
    
    func display(viewModel: AudioPlayerModule.StickyAudioPlayerViewModel) {
        controller?.display(viewModel: viewModel)
    }
}

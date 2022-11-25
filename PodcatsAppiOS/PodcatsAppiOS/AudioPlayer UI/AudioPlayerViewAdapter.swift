// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import LoadResourcePresenter
import PodcastsModule
import AudioPlayerModule
import AudioPlayerModuleiOS

final class AudioPlayerViewAdapter: ResourceView {
    typealias ResourceViewModel = LargeA
    
    
    private weak var controller: LargeAudioPlayerViewController?
    
    init(controller: LargeAudioPlayerViewController) {
        self.controller = controller
    }
    
    func receive(_ playerState: PlayerState) {
        switch playerState {
        case .noPlayingItem:
            controller?.titleLabel.text = "..."
            controller?.descriptionLabel.text = "..."
        case .updatedPlayingItem(let playingItem):
            controller?.titleLabel.text =
            controller?.descriptionLabel.text = "..."
        case .startPlayingNewItem(let playingItem):
            controller?.titleLabel.text = "..."
            controller?.descriptionLabel.text = "..."
        }
    }
}

// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import AudioPlayerModule
import AudioPlayerModuleiOS

class AudioPlayerPresentationAdapter {
    private let statePublisher: AudioPlayerStatePublisher
    private var subscription: AudioPlayerStateSubscription?
    var presenter: LargeAudioPlayerPresenter?
    
    init(statePublisher: AudioPlayerStatePublisher) {
        self.statePublisher = statePublisher
    }
}

extension AudioPlayerPresentationAdapter: LargeAudioPlayerViewLifetimeDelegate {
    
    func onOpen() {
        subscription = statePublisher.subscribe(observer: self)
    }
    
    func onClose() {
        subscription?.unsubscribe()
    }
}

extension AudioPlayerPresentationAdapter: AudioPlayerObserver {
    func receive(_ playerState: PlayerState) {
        switch playerState {
        case .noPlayingItem:
            break
            
        case .updatedPlayingItem(let playingItem):
            presenter?.didReceivePlayerState(with: playingItem)
            
        case .startPlayingNewItem(let playingItem):
            presenter?.didReceivePlayerState(with: playingItem)
        }
    }
}

extension AudioPlayerPresentationAdapter: AudioPlayerControlsDelegate {
    func seekToSeconds(_ seconds: Int) {}
    func togglePlay() {}
    func changeVolumeTo(value: Float) {}
    func seekToProgress(_ progress: Float) {}
}

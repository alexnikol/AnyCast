// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import AudioPlayerModule
import AudioPlayerModuleiOS

class StickyAudioPlayerPresentationAdapter {
    private let statePublisher: AudioPlayerStatePublisher
    private var subscription: AudioPlayerStateSubscription?
    var presenter: StickyAudioPlayerPresenter?
    var onPlayerOpenAction: () -> Void
    
    init(statePublisher: AudioPlayerStatePublisher, onPlayerOpen: @escaping () -> Void) {
        self.statePublisher = statePublisher
        self.onPlayerOpenAction = onPlayerOpen
    }
}

extension StickyAudioPlayerPresentationAdapter: StickyAudioPlayerViewDelegate {
    
    func onPlayerOpen() {
        onPlayerOpenAction()
    }
    
    func onOpen() {
        subscription = statePublisher.subscribe(observer: self)
    }
    
    func onClose() {
        subscription?.unsubscribe()
    }
}

extension StickyAudioPlayerPresentationAdapter: AudioPlayerObserver {

    func receive(_ playerState: PlayerState) {
        switch playerState {
        case .noPlayingItem:
            break
            
        case .updatedPlayingItem(let playingItem):
            DispatchQueue.immediateWhenOnMainQueueScheduler.schedule { [weak self] in
                self?.presenter?.didReceivePlayerState(with: playingItem)
            }
            
        case .startPlayingNewItem(let playingItem):
            DispatchQueue.immediateWhenOnMainQueueScheduler.schedule { [weak self] in
                self?.presenter?.didReceivePlayerState(with: playingItem)
            }
        }
    }
    
    func prepareForSeek(_ progress: AudioPlayerModule.PlayingItem.Progress) {}
}

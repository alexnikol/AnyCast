// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import SharedComponentsiOSModule
import AudioPlayerModule
import AudioPlayerModuleiOS

class StickyAudioPlayerPresentationAdapter {
    private let statePublisher: AudioPlayerStatePublisher
    private var subscription: AudioPlayerStateSubscription?
    private var thumbnaiSourceDelegate: ThumbnailSourceDelegate?
    var presenter: StickyAudioPlayerPresenter?
    var onPlayerOpenAction: () -> Void
    
    init(statePublisher: AudioPlayerStatePublisher, thumbnaiSourceDelegate: ThumbnailSourceDelegate, onPlayerOpen: @escaping () -> Void) {
        self.statePublisher = statePublisher
        self.onPlayerOpenAction = onPlayerOpen
        self.thumbnaiSourceDelegate = thumbnaiSourceDelegate
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
            handleReceivedData(playingItem: playingItem)
            
        case .startPlayingNewItem(let playingItem):
            handleReceivedData(playingItem: playingItem)
        }
    }
    
    func prepareForSeek(_ progress: AudioPlayerModule.PlayingItem.Progress) {}
    
    private func handleReceivedData(playingItem: PlayingItem) {
        DispatchQueue.immediateWhenOnMainQueueScheduler.schedule { [weak self] in
            self?.presenter?.didReceivePlayerState(with: playingItem)
            self?.thumbnaiSourceDelegate?.didUpdateSourceURL(playingItem.episode.thumbnail)
        }
    }
}

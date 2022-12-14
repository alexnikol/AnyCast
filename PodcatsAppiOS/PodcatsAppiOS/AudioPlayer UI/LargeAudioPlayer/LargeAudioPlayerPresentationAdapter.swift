// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import SharedComponentsiOSModule
import AudioPlayerModule
import AudioPlayerModuleiOS

class LargeAudioPlayerPresentationAdapter {
    private var thumbnaiSourceDelegate: ThumbnailSourceDelegate?
    private let statePublisher: AudioPlayerStatePublisher
    private var subscription: AudioPlayerStateSubscription?
    var presenter: LargeAudioPlayerPresenter?
    
    init(statePublisher: AudioPlayerStatePublisher, thumbnaiSourceDelegate: ThumbnailSourceDelegate) {
        self.statePublisher = statePublisher
        self.thumbnaiSourceDelegate = thumbnaiSourceDelegate
    }
}

extension LargeAudioPlayerPresentationAdapter: LargeAudioPlayerViewDelegate {
    
    func onOpen() {
        subscription = statePublisher.subscribe(observer: self)
    }
    
    func onClose() {
        subscription?.unsubscribe()
    }
    
    func onSelectSpeedPlayback() {
        presenter?.onSelectSpeedPlayback()
    }
}

extension LargeAudioPlayerPresentationAdapter: AudioPlayerObserver {

    func receive(_ playerState: PlayerState) {
        switch playerState {
        case .noPlayingItem:
            break
            
        case .updatedPlayingItem(let playingItem):
            self.handleReceivedData(playingItem: playingItem)
            
        case .startPlayingNewItem(let playingItem):
            self.handleReceivedData(playingItem: playingItem)
        }
    }
    
    func prepareForSeek(_ progress: AudioPlayerModule.PlayingItem.Progress) {
        DispatchQueue.immediateWhenOnMainQueueScheduler.schedule { [weak self] in
            self?.presenter?.didReceiveFutureProgressAfterSeek(with: progress)
        }
    }
    
    private func handleReceivedData(playingItem: PlayingItem) {
        DispatchQueue.immediateWhenOnMainQueueScheduler.schedule { [weak self] in
            self?.presenter?.didReceivePlayerState(with: playingItem)
            self?.thumbnaiSourceDelegate?.didUpdateSourceURL(playingItem.episode.thumbnail)
        }
    }
}

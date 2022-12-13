// Copyright © 2022 Almost Engineer. All rights reserved.


import Foundation
import AudioPlayerModule
import AudioPlayerModuleiOS

class RootTabBarPresentationAdapter {
    private let statePublisher: AudioPlayerStatePublisher
    private var subscription: AudioPlayerStateSubscription?
    var presenter: RootTabBarPresenter?
    private var isStickyPlayerVisible = false
    
    init(statePublisher: AudioPlayerStatePublisher) {
        self.statePublisher = statePublisher
    }
}

extension RootTabBarPresentationAdapter: RootTabBarViewDelegate {
    
    func onOpen() {
        subscription = statePublisher.subscribe(observer: self)
    }
    
    func onClose() {
        subscription?.unsubscribe()
    }
}

extension RootTabBarPresentationAdapter: AudioPlayerObserver {
    
    func receive(_ playerState: PlayerState) {
        switch playerState {
        case .noPlayingItem:
            updateStickyPlayer(isVisible: false)
            
        case .updatedPlayingItem:
            updateStickyPlayer(isVisible: true)
            
        case .startPlayingNewItem:
            updateStickyPlayer(isVisible: true)
        }
        
        func updateStickyPlayer(isVisible: Bool) {
            if isVisible != isStickyPlayerVisible {
                isStickyPlayerVisible = isVisible
                DispatchQueue.immediateWhenOnMainQueueScheduler.schedule { [weak self] in
                    isVisible ? self?.presenter?.showStickyPlayer() : self?.presenter?.hideStickyPlayer()
                }
            }
        }
    }
    
    func prepareForSeek(_ progress: AudioPlayerModule.PlayingItem.Progress) {}
}

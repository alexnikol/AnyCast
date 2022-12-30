// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import Combine
import AudioPlayerModule
import AudioPlayerModuleiOS

class RootTabBarPresentationAdapter {
    private let statePublisher: AudioPlayerStatePublisher
    private let audioPlayer: AudioPlayer
    private var subscription: AudioPlayerStateSubscription?
    var presenter: RootTabBarPresenter?
    private var isStickyPlayerVisible = false
    private let playbackProgressLoader: () -> LocalPlaybackProgressLoader.Publisher
    private let playbackProgressCache: PlaybackProgressCache
    private var subscriptions = Set<AnyCancellable>()
    
    init(audioPlayer: AudioPlayer,
         statePublisher: AudioPlayerStatePublisher,
         playbackProgressCache: PlaybackProgressCache,
         playbackProgressLoader: @escaping () -> LocalPlaybackProgressLoader.Publisher) {
        self.statePublisher = statePublisher
        self.audioPlayer = audioPlayer
        self.playbackProgressLoader = playbackProgressLoader
        self.playbackProgressCache = playbackProgressCache
    }
}

extension RootTabBarPresentationAdapter: RootTabBarViewDelegate {
    
    func onOpen() {
        loadPreviousPlaybackProgress()
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

private extension RootTabBarPresentationAdapter {
    
    func loadPreviousPlaybackProgress() {
        playbackProgressLoader()
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] playerState in
                    self?.audioPlayer.startPlayback(
                        fromURL: playerState.episode.audio,
                        withMeta: .init(episode: playerState.episode, podcast: playerState.podcast)
                    )
                }
            ).store(in: &subscriptions)
    }
}

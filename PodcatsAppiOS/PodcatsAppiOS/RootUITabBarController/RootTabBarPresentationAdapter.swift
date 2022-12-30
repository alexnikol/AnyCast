// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import Combine
import AudioPlayerModule
import AudioPlayerModuleiOS

class RootTabBarPresentationAdapter {
    private let statePublisher: AudioPlayerStatePublishers
    private let audioPlayer: AudioPlayer
    var presenter: RootTabBarPresenter?
    private var isStickyPlayerVisible = false
    private let playbackProgressLoader: () -> LocalPlaybackProgressLoader.Publisher
    private let playbackProgressCache: PlaybackProgressCache
    private var subscriptions = Set<AnyCancellable>()
    
    init(audioPlayer: AudioPlayer,
         statePublisher: AudioPlayerStatePublishers,
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
        
        
        statePublisher.audioPlayerStatePublisher
            .dispatchOnMainQueue()
            .sink(
                receiveValue: { [weak self] playerState in
                    self?.updateStickyPlayerState(playerState)
                })
            .store(in: &subscriptions)
    }
}

private extension RootTabBarPresentationAdapter {
    
    func updateStickyPlayerState(_ playerState: PlayerState) {
        switch playerState {
        case .noPlayingItem:
            updateStickyPlayer(isVisible: false)
            
        case .updatedPlayingItem:
            updateStickyPlayer(isVisible: true)
            
        case .startPlayingNewItem:
            updateStickyPlayer(isVisible: true)
        }
    }
    
    func updateStickyPlayer(isVisible: Bool) {
        if isVisible != isStickyPlayerVisible {
            isStickyPlayerVisible = isVisible
            isVisible ? presenter?.showStickyPlayer() : presenter?.hideStickyPlayer()
        }
    }
}

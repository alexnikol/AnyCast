// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import Combine
import AudioPlayerModule
import WidgetKit

public final class AudioPlayerStatePublishers: AudioPlayerOutputDelegate {
    public typealias AudioPlayerStatePublisher = AnyPublisher<PlayerState, Never>
    public typealias AudioPlayerPrepareForSeekPublisher = AnyPublisher<PlayingItem.Progress, Never>
    
    private let _audioPlayerStatePublisher = CurrentValueSubject<PlayerState, Never>(.noPlayingItem)
    private let _audioPlayerPrepareForSeekPublisher = PassthroughSubject<PlayingItem.Progress, Never>()
    private let playbackProgressCache: PlaybackProgressCache
    private var cancellables = Set<AnyCancellable>()
    
    var audioPlayerStatePublisher: AudioPlayerStatePublisher {
        _audioPlayerStatePublisher.eraseToAnyPublisher()
    }
    
    var audioPlayerPrepareForSeekPublisher: AudioPlayerPrepareForSeekPublisher {
        _audioPlayerPrepareForSeekPublisher.eraseToAnyPublisher()
    }
    
    public func didUpdateState(with state: PlayerState) {
        _audioPlayerStatePublisher.send(state)
    }
    
    public func prepareForProgressAfterSeekApply(futureProgress: PlayingItem.Progress) {
        _audioPlayerPrepareForSeekPublisher.send(futureProgress)
    }
    
    init(playbackProgressCache: PlaybackProgressCache) {
        self.playbackProgressCache = playbackProgressCache
        self.subscribeOnAudioPlayerEvents()
    }
    
    private func subscribeOnAudioPlayerEvents() {
        audioPlayerStatePublisher
            .sink(receiveValue: { [weak self] playbackState in
                guard let self = self else { return }
                self.savePlaybackProgress(playerState: playbackState)
                    .flatMap { [weak self] in
                        return self?.updateCurrentPlaybackProgressWidget() ?? Empty().eraseToAnyPublisher()
                    }
                    .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
                    .store(in: &self.cancellables)
            })
            .store(in: &cancellables)
    }
    
    private func savePlaybackProgress(playerState: PlayerState) -> AnyPublisher<Void, Error> {
        switch playerState {
        case let .updatedPlayingItem(playbackProgress), let .startPlayingNewItem(playbackProgress):
            return self.playbackProgressCache.cacheplaybackState(playbackProgress)
            
        case .noPlayingItem:
            return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
    }
    
    private func updateCurrentPlaybackProgressWidget() -> AnyPublisher<Void, Never> {
        WidgetCenter.shared.reloadTimelines(ofKind: "Podcast_CurrentPlayingEpisodeWidget")
        return Empty(completeImmediately: true).eraseToAnyPublisher()
    }
}

private extension PlaybackProgressCache {
    func cacheplaybackState(_ playbackProgress: PlayingItem) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { completion in
                self.save(playbackProgress, completion: { result in
                    switch result {
                    case let .some(cacheError):
                        completion(.failure(cacheError))
                        
                    case .none:
                        completion(.success(()))
                    }
                })
            }
        }.eraseToAnyPublisher()
    }
}

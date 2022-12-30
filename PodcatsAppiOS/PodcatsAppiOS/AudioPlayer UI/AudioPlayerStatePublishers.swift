// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import Combine
import AudioPlayerModule

public final class AudioPlayerStatePublishers: AudioPlayerOutputDelegate {
    public typealias AudioPlayerStatePublisher = AnyPublisher<PlayerState, Never>
    public typealias AudioPlayerPrepareForSeekPublisher = AnyPublisher<PlayingItem.Progress, Never>
    
    private let _audioPlayerStatePublisher = CurrentValueSubject<PlayerState, Never>(.noPlayingItem)
    private let _audioPlayerPrepareForSeekPublisher = PassthroughSubject<PlayingItem.Progress, Never>()
    
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
}

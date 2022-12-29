// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public extension LocalPlayingItem {
    enum State: Equatable {
        case playback(PlaybackState)
        case volumeLevel(Float)
        case progress(Progress)
        case speed(PlaybackSpeed)
    }
}

// MARK: - LocalPlayingItem.State mapping helper

extension LocalPlayingItem.State {
    func toModel() -> PlayingItem.State {
        switch self {
        case .playback(let playbackState):
            return .playback(playbackState.toModel())
            
        case .volumeLevel(let float):
            return .volumeLevel(float)
            
        case .progress(let progress):
            return .progress(progress.toModel())
            
        case .speed(let playbackSpeed):
            return .speed(playbackSpeed)
        }
    }
}

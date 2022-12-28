// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public extension PlayingItem {
    enum State: Equatable {
        case playback(PlaybackState)
        case volumeLevel(Float)
        case progress(Progress)
        case speed(PlaybackSpeed)
    }
}

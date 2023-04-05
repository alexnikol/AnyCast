// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public protocol AudioPlayerObserver {
    func receive(_ playerState: PlayerState)
    func prepareForSeek(_ progress: PlayingItem.Progress)
}

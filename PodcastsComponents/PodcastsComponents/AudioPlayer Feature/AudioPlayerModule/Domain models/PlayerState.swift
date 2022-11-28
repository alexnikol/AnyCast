// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public enum PlayerState: Equatable {
    case noPlayingItem
    case updatedPlayingItem(PlayingItem)
    case startPlayingNewItem(PlayingItem)
}

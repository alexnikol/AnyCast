// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public enum PlaybackStateViewModel {
    case playing
    case pause
    case loading
    
    public init(playbackState: PlayingItem.PlaybackState) {
        switch playbackState {
        case .playing:
            self = .playing
            
        case .pause:
            self = .pause
            
        case .loading:
            self = .loading
        }
    }
}

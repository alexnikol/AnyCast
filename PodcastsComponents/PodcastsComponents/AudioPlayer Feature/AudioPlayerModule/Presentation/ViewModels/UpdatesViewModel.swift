// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

extension LargeAudioPlayerViewModel {
    
    public enum UpdatesViewModel {
        case playback(PlaybackStateViewModel)
        case volumeLevel(Float)
        case progress(ProgressViewModel)
    }
}

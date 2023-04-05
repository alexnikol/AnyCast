// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import AudioPlayerModule

class AudioPlayerControlsDelegateNullObject: AudioPlayerControlsDelegate {
    var isPlaying = false
    func pause() {}
    func play() {}
    func changeVolumeTo(value: Float) {}
    func seekToProgress(_ progress: Float) {}
    func seekToSeconds(_ seconds: Int) {}
    func changeSpeedPlaybackTo(value: AudioPlayerModule.PlaybackSpeed) {}
    func prepareForSeek(_ progress: Float) {}
}

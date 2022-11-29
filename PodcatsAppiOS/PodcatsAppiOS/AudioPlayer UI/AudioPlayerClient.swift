// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import AudioPlayerModule

public class AudioPlayerClient: AudioPlayer, AudioPlayerControlsDelegate {
    public var delegate: AudioPlayerOutputDelegate?
    
    public func togglePlay() {}
    public func changeVolumeTo(value: Float) {}
    public func seekToProgress(_ progress: Float) {}
    public func seekToSeconds(_ seconds: Int) {}
}

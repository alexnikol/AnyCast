// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import AudioPlayerModule

public class AudioPlayerClient: AudioPlayer, AudioPlayerControlsDelegate {
    public var delegate: AudioPlayerOutputDelegate?
    
    public func togglePlay() {}
    public func onVolumeChange(value: Float) {}
    public func onSeek(value: Float) {}
}

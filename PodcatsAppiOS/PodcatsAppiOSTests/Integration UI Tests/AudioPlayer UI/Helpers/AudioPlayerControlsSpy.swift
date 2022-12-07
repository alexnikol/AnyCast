// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import AudioPlayerModule

class AudioPlayerControlsSpy: AudioPlayerControlsDelegate {
    var isPlaying = false
            
    enum Message: Equatable {
        case tooglePlaybackState
        case volumeChange(Float)
        case seekToProgress(Float)
        case seekToSeconds(Int)
    }
    
    private(set) var messages: [Message] = []
    
    func play() {
        messages.append(.tooglePlaybackState)
    }
    
    func pause() {
        messages.append(.tooglePlaybackState)
    }
    
    func changeVolumeTo(value: Float) {
        messages.append(.volumeChange(value))
    }
    
    func seekToProgress(_ progress: Float) {
        messages.append(.seekToProgress(progress))
    }
    
    func seekToSeconds(_ seconds: Int) {
        messages.append(.seekToSeconds(seconds))
    }
}

// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public protocol AudioPlayerControlsDelegate {
    var isPlaying: Bool { get }
    func play()
    func pause()
    
    // MARK: - Volume change from 0 to 1 percentage format
    func changeVolumeTo(value: Float)
    
    // MARK: - Seek change from 0 to 1 percentage format
    func seekToProgress(_ progress: Float)
    
    // MARK: - Seek change in seconds for foreward and backward convenience
    /// Use negative seconds value for backward seeking
    /// Use positive seconds value for foreward seeking
    func seekToSeconds(_ seconds: Int)
}

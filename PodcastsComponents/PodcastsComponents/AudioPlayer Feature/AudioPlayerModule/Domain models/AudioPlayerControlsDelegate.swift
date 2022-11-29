// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public protocol AudioPlayerControlsDelegate {
    func togglePlay()
    
    // MARK: - Volume change from 0 to 1 percentage format
    func changeVolumeTo(value: Float)
    
    // MARK: - Seek change from 0 to 1 percentage format
    func seekToProgress(_ progress: Float)
    
    // MARK: - Seek change in seconds for foreward and backword convenience
    /// Use negative seconds value for backword seeking
    /// Use positive seconds value for foreward seeking
    func seekToSeconds(_ seconds: Int)
}

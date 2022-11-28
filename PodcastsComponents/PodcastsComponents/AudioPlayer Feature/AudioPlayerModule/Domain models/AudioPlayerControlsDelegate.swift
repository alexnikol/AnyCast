// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public protocol AudioPlayerControlsDelegate {
    func togglePlay()
    
    // MARK: - Volume cnahge from 0 to 1 format
    func onVolumeChange(value: Float)
    
    // MARK: - Seek change from 0 to 1 format
    func onSeek(value: Float)
}

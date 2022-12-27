// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import AudioPlayerModule

extension PlaybackStateViewModel {
    
    var image: UIImage? {
        switch self {
        case .playing:
            return UIImage(systemName: "pause.fill")!
        case .pause:
            return UIImage(systemName: "play.fill")!
        case .loading:
            return nil
        }
    }
}

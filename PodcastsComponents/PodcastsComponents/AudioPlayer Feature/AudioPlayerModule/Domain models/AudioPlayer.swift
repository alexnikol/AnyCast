// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import PodcastsModule

public typealias Meta = (episode: Episode, podcast: PodcastDetails)

public protocol AudioPlayer: AudioPlayerControlsDelegate {
    var delegate: AudioPlayerOutputDelegate? { get set }
    
    func startPlayback(fromURL url: URL, withMeta meta: Meta)
}

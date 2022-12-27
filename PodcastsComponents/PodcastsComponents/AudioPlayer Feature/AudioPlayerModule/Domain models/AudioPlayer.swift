// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public class Meta {
    public let episode: any PlayingEpisode
    public let podcast: any PlayingPodcast
    
    public init(episode: any PlayingEpisode, podcast: any PlayingPodcast) {
        self.episode = episode
        self.podcast = podcast
    }
}

public protocol AudioPlayer: AudioPlayerControlsDelegate {
    var delegate: AudioPlayerOutputDelegate? { get set }
    
    func startPlayback(fromURL url: URL, withMeta meta: Meta)
}

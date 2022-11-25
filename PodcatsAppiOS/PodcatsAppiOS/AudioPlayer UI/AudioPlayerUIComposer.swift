// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import Combine
import PodcastsModule
import AudioPlayerModuleiOS

public final class AudioPlayerUIComposer {
    private init() {}
    
    public static func podcastDetailsComposedWith(data: (episode: Episode, podcast: Podcast)) -> LargeAudioPlayerViewController {
        let controller = LargeAudioPlayerViewController(
            nibName: String(describing: LargeAudioPlayerViewController.self),
            bundle: Bundle(for: LargeAudioPlayerViewController.self)
        )
        let publisher = AudioPlayerStatePublisherService.shared
        let viewAdapter = AudioPlayerViewAdapter(controller: controller)
        _ = publisher.subscribe(observer: viewAdapter)
        return controller
    }
}

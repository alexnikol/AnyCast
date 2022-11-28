// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import Combine
import PodcastsModule
import AudioPlayerModule
import AudioPlayerModuleiOS

public final class AudioPlayerUIComposer {
    private init() {}
    
    public static func largePlayerWith(data: (episode: Episode, podcast: PodcastDetails)) -> LargeAudioPlayerViewController {
        let presentationAdapter = AudioPlayerPresentationAdapter(statePublisher: AudioPlayerStatePublisherService.shared)
        let controller = LargeAudioPlayerViewController(delegate: presentationAdapter)
        let viewAdapter = AudioPlayerViewAdapter(controller: controller)
        let presenter = LargeAudioPlayerPresenter(resourceView: viewAdapter, from: data.podcast)
        presentationAdapter.presenter = presenter
        return controller
    }
}

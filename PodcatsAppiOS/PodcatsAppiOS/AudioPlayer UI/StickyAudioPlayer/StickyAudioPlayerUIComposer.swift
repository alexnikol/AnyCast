// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import Combine
import PodcastsModule
import LoadResourcePresenter
import AudioPlayerModule
import SharedComponentsiOSModule
import AudioPlayerModuleiOS

public final class StickyAudioPlayerUIComposer {
    private init() {}
    
    public static func playerWith(
        thumbnailURL: URL,
        statePublisher: AudioPlayerStatePublisher,
        controlsDelegate: AudioPlayerControlsDelegate,
        imageLoader: @escaping (URL) -> AnyPublisher<Data, Error>
    ) -> StickyAudioPlayerViewController {
        let presentationAdapter = StickyAudioPlayerPresentationAdapter(statePublisher: statePublisher)
                
        let thumbnailViewController = ThumbnailUIComposer.composeThumbnailWithImageLoader(
            thumbnailURL: thumbnailURL,
            imageLoader: imageLoader
        )
        
        let controller = StickyAudioPlayerViewController(
            delegate: presentationAdapter,
            controlsDelegate: controlsDelegate,
            thumbnailViewController: thumbnailViewController
        )
        let viewAdapter = StickyAudioPlayerViewAdapter(
            controller: controller
        )
        let presenter = StickyPlayerPresenter(resourceView: viewAdapter)
        presentationAdapter.presenter = presenter
        return controller
    }
}

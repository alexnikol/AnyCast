// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import Combine
import PodcastsModule
import LoadResourcePresenter
import AudioPlayerModule
import SharedComponentsiOSModule
import AudioPlayerModuleiOS

public final class LargeAudioPlayerUIComposer {
    private init() {}
    
    public static func largePlayerWith(
        thumbnailURL: URL,
        statePublisher: AudioPlayerStatePublisher,
        controlsDelegate: AudioPlayerControlsDelegate,
        imageLoader: @escaping (URL) -> AnyPublisher<Data, Error>
    ) -> LargeAudioPlayerViewController {
        let presentationAdapter = LargeAudioPlayerPresentationAdapter(statePublisher: statePublisher)
                
        let thumbnailViewController = ThumbnailUIComposer.composeThumbnailWithImageLoader(
            thumbnailURL: thumbnailURL,
            imageLoader: imageLoader
        )
        
        let controller = LargeAudioPlayerViewController(
            delegate: presentationAdapter,
            controlsDelegate: controlsDelegate,
            thumbnailViewController: thumbnailViewController
        )
        let viewAdapter = LargeAudioPlayerViewAdapter(
            controller: controller,
            onSpeedPlaybackChange: controlsDelegate.changeSpeedPlaybackTo
        )
        let presenter = LargeAudioPlayerPresenter(resourceView: viewAdapter)
        viewAdapter.presenter = presenter
        presentationAdapter.presenter = presenter
        return controller
    }
}

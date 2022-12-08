// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import Combine
import PodcastsModule
import LoadResourcePresenter
import AudioPlayerModule
import AudioPlayerModuleiOS

public final class AudioPlayerUIComposer {
    private init() {}
    
    public static func largePlayerWith(
        thumbnailURL: URL,
        statePublisher: AudioPlayerStatePublisher,
        controlsDelegate: AudioPlayerControlsDelegate,
        imageLoader: @escaping (URL) -> AnyPublisher<Data, Error>
    ) -> LargeAudioPlayerViewController {
        let presentationAdapter = AudioPlayerPresentationAdapter(statePublisher: statePublisher)
        
        let imageAdapter = GenericLoaderPresentationAdapter<Data, WeakRefVirtualProxy<LargeAudioPlayerViewController>>(
            loader: {
                imageLoader(thumbnailURL)
            }
        )
        
        let controller = LargeAudioPlayerViewController(
            delegate: presentationAdapter,
            controlsDelegate: controlsDelegate,
            imageLoaderDelegate: imageAdapter
        )
        let viewAdapter = AudioPlayerViewAdapter(
            controller: controller,
            onSpeedPlaybackChange: controlsDelegate.changeSpeedPlaybackTo,
            imageLoader: imageLoader
        )
        let presenter = LargeAudioPlayerPresenter(resourceView: viewAdapter)
        viewAdapter.presenter = presenter
        presentationAdapter.presenter = presenter
        
        let imagePresenter = LoadResourcePresenter(
            resourceView: WeakRefVirtualProxy(controller),
            loadingView: WeakRefVirtualProxy(controller),
            errorView: WeakRefVirtualProxy(controller),
            mapper: UIImage.trytoMake(with:)
        )
        imageAdapter.presenter = imagePresenter
        return controller
    }
}

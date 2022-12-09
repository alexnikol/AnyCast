// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import Combine
import PodcastsModule
import LoadResourcePresenter
import AudioPlayerModule
import SharedComponentsiOSModule
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
        
        let imageAdapter = GenericLoaderPresentationAdapter<Data, WeakRefVirtualProxy<ThumbnailViewController>>(
            loader: {
                imageLoader(thumbnailURL)
            }
        )
        
        let thumbnailViewController = ThumbnailViewController(loaderDelegate: imageAdapter)
        let imagePresenter = LoadResourcePresenter(
            resourceView: WeakRefVirtualProxy(thumbnailViewController),
            loadingView: WeakRefVirtualProxy(thumbnailViewController),
            errorView: WeakRefVirtualProxy(thumbnailViewController),
            mapper: UIImage.trytoMake(with:)
        )
        imageAdapter.presenter = imagePresenter
        
        let controller = LargeAudioPlayerViewController(
            delegate: presentationAdapter,
            controlsDelegate: controlsDelegate,
            thumbnailViewController: thumbnailViewController
        )
        let viewAdapter = AudioPlayerViewAdapter(
            controller: controller,
            onSpeedPlaybackChange: controlsDelegate.changeSpeedPlaybackTo,
            imageLoader: imageLoader
        )
        let presenter = LargeAudioPlayerPresenter(resourceView: viewAdapter)
        viewAdapter.presenter = presenter
        presentationAdapter.presenter = presenter
        return controller
    }
}

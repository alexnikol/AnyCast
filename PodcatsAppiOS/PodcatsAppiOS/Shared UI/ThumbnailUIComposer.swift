// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import Combine
import SharedComponentsiOSModule
import LoadResourcePresenter

public final class ThumbnailUIComposer {
    public static func composeThumbnailWithImageLoader(
        thumbnailURL: URL,
        imageLoader: @escaping (URL) -> AnyPublisher<Data, Error>
    ) -> ThumbnailViewController {
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
        return thumbnailViewController
    }
    
    public static func composeThumbnailWithDynamicImageLoader(
        imageLoader: @escaping (URL) -> AnyPublisher<Data, Error>
    ) -> (controller: ThumbnailDynamicViewController, source: ThumbnailSourceDelegate) {
        let imageAdapter = ThumbnailDynamicPresentationAdapter<Data, WeakRefVirtualProxy<ThumbnailDynamicViewController>>(loader: imageLoader)
        let thumbnailViewController = ThumbnailDynamicViewController()
        let imagePresenter = LoadResourcePresenter(
            resourceView: WeakRefVirtualProxy(thumbnailViewController),
            loadingView: WeakRefVirtualProxy(thumbnailViewController),
            errorView: WeakRefVirtualProxy(thumbnailViewController),
            mapper: UIImage.trytoMake(with:)
        )
        imageAdapter.presenter = imagePresenter
        return (thumbnailViewController, imageAdapter)
    }
}

// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import Combine
import LoadResourcePresenter
import SharedHelpersiOSModule
import PodcastsModule
import PodcastsModuleiOS

public final class PodcastDetailsUIComposer {
    private init() {}
    
    public static func podcastDetailsComposedWith(
        podcastID: String,
        podcastsLoader: @escaping (String) -> AnyPublisher<PodcastDetails, Error>,
        imageLoader: @escaping (URL) -> AnyPublisher<Data, Error>
    ) -> ListViewController {
        let presentationAdapter = PodcastDetailsLoaderPresentationAdapter(
            podcastID: podcastID,
            loader: podcastsLoader
        )
        let refreshController = RefreshViewController(delegate: presentationAdapter)
        let controller = ListViewController(refreshController: refreshController)
        
        presentationAdapter.presenter = LoadResourcePresenter(
            resourceView: PodcastDetailsViewAdapter(
                controller: controller,
                imageLoader: imageLoader
            ),
            loadingView: WeakRefVirtualProxy(refreshController),
            errorView: WeakRefVirtualProxy(refreshController),
            mapper: PodcastDetailsPresenter.map
        )
        return controller
    }
}

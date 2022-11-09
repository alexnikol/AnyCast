// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import Combine
import LoadResourcePresenter
import PodcastsModule
import PodcastsModuleiOS

public final class PodcastDetailsUIComposer {
    private init() {}
    
    public static func podcastDetailsComposedWith(
        genreID: Int,
        podcastsLoader: @escaping (Int) -> AnyPublisher<BestPodcastsList, Error>,
        imageLoader: @escaping (URL) -> AnyPublisher<Data, Error>
    ) -> ListViewController {
        let presentationAdapter = BestPodcastsLoaderPresentationAdapter(
            genreID: genreID,
            loader: podcastsLoader
        )
        let refreshController = RefreshViewController(delegate: presentationAdapter)
        let controller = ListViewController(refreshController: refreshController)
        
        presentationAdapter.presenter = LoadResourcePresenter(
            resourceView: BestPodcastsViewAdapter(
                controller: controller,
                imageLoader: imageLoader
            ),
            loadingView: WeakRefVirtualProxy(refreshController),
            errorView: WeakRefVirtualProxy(refreshController),
            mapper: BestPodcastsPresenter.map
        )
        return controller
    }
}

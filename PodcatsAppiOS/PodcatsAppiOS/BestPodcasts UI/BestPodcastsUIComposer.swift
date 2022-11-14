// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import Combine
import LoadResourcePresenter
import SharedHelpersiOSModule
import PodcastsModule
import PodcastsModuleiOS

public final class BestPodcastsUIComposer {
    private init() {}
    
    public static func bestPodcastComposed(
        genreID: Int,
        podcastsLoader: @escaping (Int) -> AnyPublisher<BestPodcastsList, Error>,
        imageLoader: @escaping (URL) -> AnyPublisher<Data, Error>,
        selection: @escaping (Podcast) -> Void
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
                imageLoader: imageLoader,
                selection: selection
            ),
            loadingView: WeakRefVirtualProxy(refreshController),
            errorView: WeakRefVirtualProxy(refreshController),
            mapper: BestPodcastsPresenter.map
        )
        return controller
    }
}

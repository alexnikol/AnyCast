// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import BestPodcastsList
import LoadResourcePresenter

public final class BestPodcastsUIComposer {
    private init() {}
    
    public static func bestPodcastComposed(
        genreID: Int,
        podcastsLoader: BestPodcastsLoader,
        imageLoader: PodcastImageDataLoader
    ) -> ListViewController {
        let presentationAdapter = BestPodcastsLoaderPresentationAdapter(
            genreID: genreID,
            loader: MainQueueDispatchDecorator(decoratee: podcastsLoader)
        )
        let refreshController = RefreshViewController(delegate: presentationAdapter)
        let controller = ListViewController(refreshController: refreshController)
        
        presentationAdapter.presenter = LoadResourcePresenter(
            resourceView: BestPodcastsViewAdapter(
                controller: controller,
                imageLoader: MainQueueDispatchDecorator(decoratee: imageLoader)
            ),
            loadingView: WeakRefVirtualProxy(refreshController),
            errorView: WeakRefVirtualProxy(refreshController),
            mapper: BestPodcastsPresenter.map
        )
        return controller
    }
}

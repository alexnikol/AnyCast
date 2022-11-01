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
    ) -> BestPodcastsListViewController {
        let presentationAdapter = BestPodcastsLoaderPresentationAdapter(
            genreID: genreID,
            loader: MainQueueDispatchDecorator(decoratee: podcastsLoader)
        )
        let refreshController = BestPodcastsListRefreshViewController(delegate: presentationAdapter)
        let controller = BestPodcastsListViewController(refreshController: refreshController)
        
        presentationAdapter.presenter = LoadResourcePresenter(
            resourceView: BestPodcastsViewAdapter(
                controller: controller,
                imageLoader: MainQueueDispatchDecorator(decoratee: imageLoader)
            ),
            loadingView: WeakRefVirtualProxy(refreshController),
            mapper: BestPodcastsPresenter.map
        )
        return controller
    }
}

// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import Combine
import LoadResourcePresenter
import SharedComponentsiOSModule
import PodcastsModule
import PodcastsModuleiOS

public enum PodcastDetailsUIComposer {
    
    public static func podcastDetailsComposedWith(
        podcastID: String,
        podcastsLoader: @escaping (String) -> AnyPublisher<PodcastDetails, Error>,
        imageLoader: @escaping (URL) -> AnyPublisher<Data, Error>,
        selection: @escaping (Episode, PodcastDetails) -> Void
    ) -> ListViewController {
        
        let genericPresentationAdapter = GenericLoaderPresentationAdapter<PodcastDetails, PodcastDetailsViewAdapter>(loader: {
            podcastsLoader(podcastID)
        })
        let refreshController = RefreshViewController(delegate: genericPresentationAdapter)
        let controller = ListViewController(refreshController: refreshController)
        
        var podcastDetails: PodcastDetails?
        genericPresentationAdapter.presenter = LoadResourcePresenter(
            resourceView: PodcastDetailsViewAdapter(
                controller: controller,
                imageLoader: imageLoader,
                selection: { episode in
                    guard let podcastDetails = podcastDetails else { return }
                    selection(episode, podcastDetails)
                }
            ),
            loadingView: WeakRefVirtualProxy(refreshController),
            errorView: WeakRefVirtualProxy(refreshController),
            mapper: { data in
                podcastDetails = data
                return PodcastDetailsPresenter.map(data)
            }
        )
        return controller
    }
}

// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import Combine
import LoadResourcePresenter
import SharedComponentsiOSModule
import PodcastsModule
import PodcastsModuleiOS
import SearchContentModule

public enum TypeheadSearchUIComposer {
    
    public static func searchComposedWith(
        searchLoader: @escaping (String) -> AnyPublisher<TypeheadSearchContentResult, Error>
    ) -> ListViewController {
        let presentationAdapter = GenericLoaderPresentationAdapter<TypeheadSearchContentResult, BestPodcastsViewAdapter>(
            loader: { searchLoader("") }
        )
        let refreshController = RefreshViewController(delegate: presentationAdapter)
        let controller = ListViewController(refreshController: refreshController)
        
//        presentationAdapter.presenter = LoadResourcePresenter(
//            resourceView: BestPodcastsViewAdapter(
//                controller: controller,
//                imageLoader: imageLoader,
//                selection: selection
//            ),
//            loadingView: WeakRefVirtualProxy(refreshController),
//            errorView: WeakRefVirtualProxy(refreshController),
//            mapper: BestPodcastsPresenter.map
//        )
        return controller
    }
}

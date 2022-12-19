// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import Combine
import LoadResourcePresenter
import SharedComponentsiOSModule
import SearchContentModule

public enum GeneralSearchUIComposer {
    
    public static func searchComposedWith() -> (controller: ListViewController, sourceDelegate: GeneralSearchSourceDelegate) {
        let presentationAdapter = GeneralSearchPresentationAdapter()
        let presentationAdapter2 = GenericLoaderPresentationAdapter<GeneralSearchContentResult, GeneralSearchViewAdapter>(
            loader: { Empty().eraseToAnyPublisher() }
        )
        let refreshController = RefreshViewController(delegate: presentationAdapter2)
        let controller = ListViewController(refreshController: nil)
        controller.title = "Search"
        
        let searchController = UIViewController()
        searchController.view.backgroundColor = .red
        controller.navigationItem.searchController = UISearchController(searchResultsController: searchController)
        
        presentationAdapter2.presenter = LoadResourcePresenter(
            resourceView: GeneralSearchViewAdapter(
                controller: controller
            ),
            loadingView: WeakRefVirtualProxy(refreshController),
            errorView: WeakRefVirtualProxy(refreshController),
            mapper: { _ in "" }
        )
        return (controller, presentationAdapter)
    }
}

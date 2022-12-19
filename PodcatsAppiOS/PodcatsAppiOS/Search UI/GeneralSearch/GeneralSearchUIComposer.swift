// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import Combine
import LoadResourcePresenter
import SharedComponentsiOSModule
import SearchContentModule

public enum GeneralSearchUIComposer {
    
    public static func searchComposedWith() -> ListViewController {
        let presentationAdapter = GenericLoaderPresentationAdapter<GeneralSearchContentResult, GeneralSearchViewAdapter>(
            loader: { Empty().eraseToAnyPublisher() }
        )
        let refreshController = RefreshViewController(delegate: presentationAdapter)
        let controller = ListViewController(refreshController: nil)
        controller.title = "Search"
        
        let searchController = UIViewController()
        searchController.view.backgroundColor = .red
        controller.navigationItem.searchController = UISearchController(searchResultsController: searchController)
        
        presentationAdapter.presenter = LoadResourcePresenter(
            resourceView: GeneralSearchViewAdapter(
                controller: controller
            ),
            loadingView: WeakRefVirtualProxy(refreshController),
            errorView: WeakRefVirtualProxy(refreshController),
            mapper: { _ in "" }
        )
        
        let newPresentationAdapter = TypeSearchPresentationAdapter()
        return controller
    }
}

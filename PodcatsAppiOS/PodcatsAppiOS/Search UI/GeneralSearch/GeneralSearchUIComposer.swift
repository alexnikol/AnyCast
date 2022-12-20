// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import Combine
import LoadResourcePresenter
import SharedComponentsiOSModule
import SearchContentModule

public enum GeneralSearchUIComposer {
    
    public static func searchComposedWith(searchController: UISearchController) -> (controller: ListViewController, sourceDelegate: GeneralSearchSourceDelegate) {
        let presentationAdapter = GeneralSearchPresentationAdapter()
        let presentationAdapter2 = GenericLoaderPresentationAdapter<GeneralSearchContentResult, GeneralSearchViewAdapter>(
            loader: { Empty().eraseToAnyPublisher() }
        )
        let controller = ListViewController(refreshController: nil)
        controller.title = "Search"
        controller.navigationItem.searchController = searchController
        let nullObjectPresenterStateView = NullObjectStateResourceView()
        
        presentationAdapter2.presenter = LoadResourcePresenter(
            resourceView: GeneralSearchViewAdapter(
                controller: controller
            ),
            loadingView: nullObjectPresenterStateView,
            errorView: nullObjectPresenterStateView,
            mapper: { _ in "" }
        )
        return (controller, presentationAdapter)
    }
}

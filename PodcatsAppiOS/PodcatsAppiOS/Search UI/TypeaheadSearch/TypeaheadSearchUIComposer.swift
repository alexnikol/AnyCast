// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import Combine
import SharedComponentsiOSModule
import LoadResourcePresenter
import SearchContentModule
import SearchContentModuleiOS

public enum TypeaheadSearchUIComposer {
    
    public static func searchComposedWith(
        searchLoader: @escaping (String) -> AnyPublisher<TypeaheadSearchContentResult, Error>,
        onTermSelect: @escaping (String) -> Void
    ) -> TypeaheadListViewController {
        let presentationAdapter = TypeaheadSearchPresentationAdapter(loader: searchLoader)
        let controller = TypeaheadListViewController(searchDelegate: presentationAdapter)
        let nullObjectPresenterStateView = NullObjectStateResourceView()
        
        presentationAdapter.presenter = LoadResourcePresenter(
            resourceView: TypeaheadSearchViewAdapter(
                controller: controller,
                onTermSelect: onTermSelect
            ),
            loadingView: WeakRefVirtualProxy(nullObjectPresenterStateView),
            errorView: WeakRefVirtualProxy(nullObjectPresenterStateView),
            mapper: TypeaheadSearchContentPresenter.map
        )
        return controller
    }
}

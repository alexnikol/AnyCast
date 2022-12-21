// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import Combine
import SharedComponentsiOSModule
import LoadResourcePresenter
import SearchContentModule
import SearchContentModuleiOS

public enum TypeheadSearchUIComposer {
    
    public static func searchComposedWith(
        searchLoader: @escaping (String) -> AnyPublisher<TypeheadSearchContentResult, Error>,
        onTermSelect: @escaping (String) -> Void
    ) -> TypeheadListViewController {
        let presentationAdapter = TypeheadSearchPresentationAdapter(loader: searchLoader)
        let controller = TypeheadListViewController(searchDelegate: presentationAdapter)
        let nullObjectPresenterStateView = NullObjectStateResourceView()
        
        presentationAdapter.presenter = LoadResourcePresenter(
            resourceView: TypeheadSearchViewAdapter(
                controller: controller,
                onTermSelect: onTermSelect
            ),
            loadingView: WeakRefVirtualProxy(nullObjectPresenterStateView),
            errorView: WeakRefVirtualProxy(nullObjectPresenterStateView),
            mapper: TypeheadSearchContentPresenter.map
        )
        return controller
    }
}
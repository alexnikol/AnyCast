// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import Combine
import LoadResourcePresenter
import SearchContentModule
import SharedComponentsiOSModule

public enum TypeheadSearchUIComposer {
    
    public static func searchComposedWith(
        searchLoader: @escaping (String) -> AnyPublisher<TypeheadSearchContentResult, Error>
    ) -> (controller: ListViewController, sourceDelegate: TypeheadSearchSourceDelegate) {
        let presentationAdapter = GenericLoaderPresentationAdapter<TypeheadSearchContentResult, TypeheadSearchViewAdapter>(
            loader: { searchLoader("star wars") }
        )
        let refreshController = RefreshViewController(delegate: presentationAdapter)
        let controller = ListViewController(refreshController: refreshController)
        
        presentationAdapter.presenter = LoadResourcePresenter(
            resourceView: TypeheadSearchViewAdapter(
                controller: controller
            ),
            loadingView: WeakRefVirtualProxy(refreshController),
            errorView: WeakRefVirtualProxy(refreshController),
            mapper: TypeheadSearchContentPresenter.map
        )
        
        let newPresentationAdapter = TypeheadSearchPresentationAdapter()
        
        return (controller, newPresentationAdapter)
    }
}

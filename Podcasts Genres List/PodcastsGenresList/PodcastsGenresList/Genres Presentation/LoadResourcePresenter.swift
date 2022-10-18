// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public protocol ResourceView {
    associatedtype ResourceViewModel
    
    func display(_ viewModel: ResourceViewModel)
}

public class LoadResourcePresenter<Resource, View: ResourceView> {
    public typealias Mapper = (Resource) -> (View.ResourceViewModel)
    let resourceView: View
    let loadingView: GenresLoadingView
    let mapper: Mapper
    
    public init(resourceView: View, loadingView: GenresLoadingView, mapper: @escaping Mapper) {
        self.resourceView = resourceView
        self.loadingView = loadingView
        self.mapper = mapper
    }
    
    public func didStartLoading() {
        loadingView.display(.init(isLoading: true))
    }
    
    public func didFinishLoading(with error: Error) {
        loadingView.display(.init(isLoading: false))
    }
    
    public func didFinishLoading(with resource: Resource) {
        resourceView.display(mapper(resource))
        loadingView.display(.init(isLoading: false))
    }
}

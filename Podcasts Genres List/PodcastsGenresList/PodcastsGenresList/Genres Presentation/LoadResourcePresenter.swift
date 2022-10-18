// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public protocol ResourceView {
     func display(_ viewModel: String)
}

public class LoadResourcePresenter {
    public typealias Mapper = (String) -> (String)
    let resourceView: ResourceView
    let loadingView: GenresLoadingView
    let mapper: Mapper
        
    public init(resourceView: ResourceView, loadingView: GenresLoadingView, mapper: @escaping Mapper) {
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
    
    public func didFinishLoading(with resource: String) {
        resourceView.display(mapper(resource))
        loadingView.display(.init(isLoading: false))
    }
}

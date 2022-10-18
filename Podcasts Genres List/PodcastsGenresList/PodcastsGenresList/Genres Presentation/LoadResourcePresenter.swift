// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public protocol ResourceView {
    associatedtype ResourceViewModel
    
    func display(_ viewModel: ResourceViewModel)
}

public struct ResourceLoadingViewModel {
    public let isLoading: Bool
}

public protocol ResourceLoadingView {
    func display(_ viewModel: ResourceLoadingViewModel)
}

public class LoadResourcePresenter<Resource, View: ResourceView> {
    public typealias Mapper = (Resource) -> (View.ResourceViewModel)
    let resourceView: View
    let loadingView: ResourceLoadingView
    let mapper: Mapper
    
    public init(resourceView: View, loadingView: ResourceLoadingView, mapper: @escaping Mapper) {
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

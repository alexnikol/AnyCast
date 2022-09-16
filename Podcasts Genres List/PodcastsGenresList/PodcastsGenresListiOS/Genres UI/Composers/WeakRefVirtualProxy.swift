// Copyright © 2022 Almost Engineer. All rights reserved.

final class WeakRefVirtualProxy<T: AnyObject> {
    private weak var object: T?
    
    init(_ object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: GenresLoadingView where T: GenresLoadingView {
    func display(_ viewModel: GenresLoadingViewModel) {
        object?.display(viewModel)
    }
}

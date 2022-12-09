// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import LoadResourcePresenter

public class ThumbnailViewController: NSObject, RefreshViewControllerDelegate {
    private let loaderDelegate: RefreshViewControllerDelegate
    public weak var view: ThumbnailView?
    
    public init(loaderDelegate: RefreshViewControllerDelegate) {
        self.loaderDelegate = loaderDelegate
    }
    
    public func didRequestLoading() {
        loaderDelegate.didRequestLoading()
    }
    
    public func didRequestCancel() {
        loaderDelegate.didRequestCancel()
    }
}

extension ThumbnailViewController: ResourceView, ResourceLoadingView, ResourceErrorView {
    public typealias ResourceViewModel = UIImage
    
    public func display(_ viewModel: UIImage) {
        view?.imageView.image = viewModel
    }
    
    public func display(_ viewModel: ResourceLoadingViewModel) {
        view?.imageInnerContainer.isShimmering = viewModel.isLoading
    }
    
    public func display(_ viewModel: ResourceErrorViewModel) {
        view?.imageView.image = nil
    }
}

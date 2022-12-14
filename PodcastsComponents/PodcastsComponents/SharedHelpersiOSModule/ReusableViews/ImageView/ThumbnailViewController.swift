// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import LoadResourcePresenter

public protocol AsyncImageView: AnyObject {
    var rootImage: UIImageView? { get }
    var shimmeringContainer: UIView? { get }
}

public class ThumbnailViewController: NSObject, RefreshViewControllerDelegate {
    private let loaderDelegate: RefreshViewControllerDelegate
    public weak var view: AsyncImageView?
    
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
        view?.rootImage?.image = viewModel
    }
    
    public func display(_ viewModel: ResourceLoadingViewModel) {
        view?.shimmeringContainer?.isShimmering = viewModel.isLoading
    }
    
    public func display(_ viewModel: ResourceErrorViewModel) {
        view?.rootImage?.image = nil
    }
}

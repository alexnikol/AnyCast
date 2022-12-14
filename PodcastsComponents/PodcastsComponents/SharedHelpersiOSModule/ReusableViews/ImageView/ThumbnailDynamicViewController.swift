// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import LoadResourcePresenter

public class ThumbnailDynamicViewController: NSObject {
    public weak var view: AsyncImageView?
}

extension ThumbnailDynamicViewController: ResourceView, ResourceLoadingView, ResourceErrorView {
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

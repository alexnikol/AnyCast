// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import LoadResourcePresenter

public protocol RefreshViewControllerDelegate {
    func didRequestLoading()
}

public final class RefreshViewController: NSObject {
    public private(set) lazy var view = loadView()
    private let delegate: RefreshViewControllerDelegate
    
    public init(delegate: RefreshViewControllerDelegate) {
        self.delegate = delegate
    }
    
    @objc
    public func refresh() {
        delegate.didRequestLoading()
    }
    
    private func loadView() -> UIRefreshControl {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
}

extension RefreshViewController: ResourceLoadingView {
    public func display(_ viewModel: ResourceLoadingViewModel) {
        if viewModel.isLoading {
            view.beginRefreshing()
        } else {
            view.endRefreshing()
        }
    }
}

extension RefreshViewController: ResourceErrorView {
    public func display(_ viewModel: ResourceErrorViewModel) {}
}

// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import LoadResourcePresenter

public protocol BestPodcastsListRefreshViewControllerDelegate {
    func didRequestLoadingPodcasts()
}

public final class BestPodcastsListRefreshViewController: NSObject {
    private(set) lazy var view = loadView()
    private let delegate: BestPodcastsListRefreshViewControllerDelegate
    
    public init(delegate: BestPodcastsListRefreshViewControllerDelegate) {
        self.delegate = delegate
    }
    
    @objc
    func refresh() {
        delegate.didRequestLoadingPodcasts()
    }
    
    private func loadView() -> UIRefreshControl {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
}

extension BestPodcastsListRefreshViewController: ResourceLoadingView {
    public func display(_ viewModel: ResourceLoadingViewModel) {
        if viewModel.isLoading {
            view.beginRefreshing()
        } else {
            view.endRefreshing()
        }
    }
}

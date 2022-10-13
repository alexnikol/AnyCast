// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import PodcastsGenresList

public protocol GenresRefreshViewControllerDelegate {
    func didRequestLoadingGenres()
}

public final class GenresRefreshViewController: NSObject {
    private(set) lazy var view = loadView()
    private let delegate: GenresRefreshViewControllerDelegate
    
    public init(delegate: GenresRefreshViewControllerDelegate) {
        self.delegate = delegate
    }
    
    @objc
    func refresh() {
        delegate.didRequestLoadingGenres()
    }
    
    private func loadView() -> UIRefreshControl {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
}

extension GenresRefreshViewController: GenresLoadingView {
    public func display(_ viewModel: GenresLoadingViewModel) {
        if viewModel.isLoading {
            view.beginRefreshing()
        } else {
            view.endRefreshing()
        }
    }
}

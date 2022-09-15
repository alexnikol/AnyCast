// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit

final class GenresRefreshViewController: NSObject {
    private(set) lazy var view = loadView()
    private let load: () -> Void
    
    init(load: @escaping () -> Void) {
        self.load = load
    }
    
    @objc
    func refresh() {
        load()
    }
    
    private func loadView() -> UIRefreshControl {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
}

extension GenresRefreshViewController: GenresLoadingView {
    func display(_ viewModel: GenresLoadingViewModel) {
        if viewModel.isLoading {
            view.beginRefreshing()
        } else {
            view.endRefreshing()
        }
    }
}

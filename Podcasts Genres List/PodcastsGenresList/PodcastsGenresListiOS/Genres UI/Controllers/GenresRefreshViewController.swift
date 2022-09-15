// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit

final class GenresRefreshViewController: NSObject {
    private let presenter: GenresPresenter
    private(set) lazy var view = loadView()
    
    init(presenter: GenresPresenter) {
        self.presenter = presenter
    }
    
    @objc
    func refresh() {
        presenter.loadGenres()
    }
    
    private func loadView() -> UIRefreshControl {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
}

extension GenresRefreshViewController: GenresLoadingView {
    func display(isLoading: Bool) {
        if isLoading {
            view.beginRefreshing()
        } else {
            view.endRefreshing()
        }
    }
}

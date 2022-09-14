// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import PodcastsGenresList

final class GenresRefreshViewController: NSObject {
    private(set) lazy var view: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }()
    
    private let genresLoader: GenresLoader
    
    init(genresLoader: GenresLoader) {
        self.genresLoader = genresLoader
    }
    
    var onRefresh: (([Genre]) -> Void)?
    
    @objc
    func refresh() {
        view.beginRefreshing()
        genresLoader.load { [weak self] result in
            if let genres = try? result.get() {
                self?.onRefresh?(genres)
            }
            self?.view.endRefreshing()
        }
    }
}

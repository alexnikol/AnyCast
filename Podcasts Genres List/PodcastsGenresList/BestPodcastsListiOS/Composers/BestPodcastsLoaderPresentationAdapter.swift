// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import LoadResourcePresenter
import BestPodcastsList

final class BestPodcastsLoaderPresentationAdapter: BestPodcastsListRefreshViewControllerDelegate {
    private let genreID: Int
    private let loader: BestPodcastsLoader
    var presenter: LoadResourcePresenter<BestPodcastsList, BestPodcastsViewAdapter>?
    
    init(genreID: Int, loader: BestPodcastsLoader) {
        self.genreID = genreID
        self.loader = loader
    }
     
    func didRequestLoadingPodcasts() {
        presenter?.didStartLoading()
        loader.load(by: genreID) { [weak self] result in
            switch result {
            case let .success(data):
                self?.presenter?.didFinishLoading(with: data)
            case let .failure(error):
                self?.presenter?.didFinishLoading(with: error)
            }
        }
    }
}

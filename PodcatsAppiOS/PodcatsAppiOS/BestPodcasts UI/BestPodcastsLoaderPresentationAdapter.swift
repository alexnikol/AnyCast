// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import Combine
import LoadResourcePresenter
import BestPodcastsList
import BestPodcastsListiOS

final class BestPodcastsLoaderPresentationAdapter: RefreshViewControllerDelegate {
    private let genreID: Int
    private let loader: (Int) -> AnyPublisher<BestPodcastsList, Error>
    private var cancellable: AnyCancellable?
    var presenter: LoadResourcePresenter<BestPodcastsList, BestPodcastsViewAdapter>?
    
    init(genreID: Int, loader: @escaping (Int) -> AnyPublisher<BestPodcastsList, Error>) {
        self.genreID = genreID
        self.loader = loader
    }
    
    func didRequestLoading() {
        presenter?.didStartLoading()
        
        cancellable = loader(genreID)
            .dispatchOnMainQueue()
            .sink(
                receiveCompletion: { [weak self] result in
                    switch result {
                    case .finished: break
                        
                    case let .failure(error):
                        self?.presenter?.didFinishLoading(with: error)
                    }
                },
                receiveValue: { [weak self] data in
                    self?.presenter?.didFinishLoading(with: data)
                }
            )
    }
}

// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import Combine
import PodcastsGenresList
import PodcastsGenresListiOS
import LoadResourcePresenter

final class GenresLoaderPresentationAdapter: GenresRefreshViewControllerDelegate {
    private let genresLoader: () -> AnyPublisher<[Genre], Error>
    private var cancellable: Cancellable?
    var presenter: LoadResourcePresenter<[Genre], GenresViewAdapter>?
    
    init(genresLoader: @escaping () -> AnyPublisher<[Genre], Error>) {
        self.genresLoader = genresLoader
    }
    
    func didRequestLoadingGenres() {
        presenter?.didStartLoading()
        
        cancellable = genresLoader()
            .dispatchOnMainQueue()
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished: break
                        
                    case let .failure(error):
                        self?.presenter?.didFinishLoading(with: error)
                    }
                },
                receiveValue: { [weak self] genres in
                    self?.presenter?.didFinishLoading(with: genres)
                }
            )
    }
}

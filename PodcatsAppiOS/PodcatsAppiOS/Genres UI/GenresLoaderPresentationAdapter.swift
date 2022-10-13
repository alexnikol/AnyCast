// Copyright © 2022 Almost Engineer. All rights reserved.

import PodcastsGenresList
import PodcastsGenresListiOS

final class GenresLoaderPresentationAdapter: GenresRefreshViewControllerDelegate {
    private let genresLoader: GenresLoader
    var presenter: GenresPresenter?
    
    init(genresLoader: GenresLoader) {
        self.genresLoader = genresLoader
    }
    
    func didRequestLoadingGenres() {
        presenter?.didStartLoadingGenres()
        genresLoader.load { [weak self] result in
            switch result {
            case let .success(genres):
                self?.presenter?.didFinishLoadingGenres(with: genres)
                
            case let .failure(error):
                self?.presenter?.didFinishLoading(with: error)
            }
        }
    }
}

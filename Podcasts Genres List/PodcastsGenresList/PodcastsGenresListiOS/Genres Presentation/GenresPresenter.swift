// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import PodcastsGenresList

struct GenresLoadingViewModel {
    let isLoading: Bool
}

protocol GenresLoadingView {
    func display(_ viewModel: GenresLoadingViewModel)
}

struct GenresViewModel {
    let genres: [Genre]
}

protocol GenresView {
    func display(_ viewModel: GenresViewModel)
}

final class GenresPresenter {
    private let genresLoader: GenresLoader
    
    init(genresLoader: GenresLoader) {
        self.genresLoader = genresLoader
    }
    
    var genresView: GenresView?
    var loadingView: GenresLoadingView?
        
    func loadGenres() {
        loadingView?.display(.init(isLoading: true))
        genresLoader.load { [weak self] result in
            if let genres = try? result.get() {
                self?.genresView?.display(.init(genres: genres))
            }
            self?.loadingView?.display(.init(isLoading: false))
        }
    }
}

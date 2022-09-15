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
    var genresView: GenresView?
    var loadingView: GenresLoadingView?
        
    func didStartLoadingGenres() {
        loadingView?.display(.init(isLoading: true))
    }
    
    func didFinishLoadingGenres(with genres: [Genre]) {
        genresView?.display(.init(genres: genres))
        loadingView?.display(.init(isLoading: false))
    }
    
    func didFinishLoading(with error: Error) {
        loadingView?.display(.init(isLoading: false))
    }
}

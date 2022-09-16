// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import PodcastsGenresList

struct GenresLoadingViewModel {
    let isLoading: Bool
}

protocol GenresLoadingView {
    func display(_ viewModel: GenresLoadingViewModel)
}

struct GenreViewModel {
    let name: String
}

struct GenresViewModel {
    let genres: [GenreViewModel]
}

protocol GenresView {
    func display(_ viewModel: GenresViewModel)
}

final class GenresPresenter {
    let genresView: GenresView
    let loadingView: GenresLoadingView
        
    static var title: String {
        return NSLocalizedString("GENRES_VIEW_TITLE", tableName: "Genres", bundle: .init(for: Self.self), comment: "Title for the genres view")
    }
    
    init(genresView: GenresView, loadingView: GenresLoadingView) {
        self.genresView = genresView
        self.loadingView = loadingView
    }
    
    func didStartLoadingGenres() {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async { [weak self] in
                self?.didStartLoadingGenres()
            }
        }
        loadingView.display(.init(isLoading: true))
    }
    
    func didFinishLoadingGenres(with genres: [Genre]) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async { [weak self] in
                self?.didFinishLoadingGenres(with: genres)
            }
        }
        genresView.display(.init(genres: genres.map { GenreViewModel(name: $0.name) }))
        loadingView.display(.init(isLoading: false))
    }
    
    func didFinishLoading(with error: Error) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async { [weak self] in
                self?.didFinishLoading(with: error)
            }
        }
        loadingView.display(.init(isLoading: false))
    }
}

// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import PodcastsGenresList

protocol GenresLoadingView: AnyObject {
    func display(isLoading: Bool)
}

protocol GenresView {
    func display(genres: [Genre])
}

final class GenresPresenter {
    private let genresLoader: GenresLoader
    
    init(genresLoader: GenresLoader) {
        self.genresLoader = genresLoader
    }
    
    var genresView: GenresView?
    weak var loadingView: GenresLoadingView?
        
    func loadGenres() {
        loadingView?.display(isLoading: true)
        genresLoader.load { [weak self] result in
            if let genres = try? result.get() {
                self?.genresView?.display(genres: genres)
            }
            self?.loadingView?.display(isLoading: false)
        }
    }
}

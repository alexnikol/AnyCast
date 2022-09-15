// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import PodcastsGenresList

final class GenresViewModel {
    private let genresLoader: GenresLoader
    
    init(genresLoader: GenresLoader) {
        self.genresLoader = genresLoader
    }
    
    var onChange: ((GenresViewModel) -> Void)?
    var onGenresLoad: (([Genre]) -> Void)?
    
    private(set) var isLoading: Bool = false {
        didSet { onChange?(self) }
    }
    
    func loadGenres() {
        isLoading = true
        genresLoader.load { [weak self] result in
            if let genres = try? result.get() {
                self?.onGenresLoad?(genres)
            }
            self?.isLoading = false
        }
    }
}

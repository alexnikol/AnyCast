// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation
import PodcastsGenresList

final class GenresViewModel {
    typealias Observer<T> = (T) -> Void
    
    private let genresLoader: GenresLoader
    
    init(genresLoader: GenresLoader) {
        self.genresLoader = genresLoader
    }
    
    var onLoadingStateChange: Observer<Bool>?
    var onGenresLoad: Observer<[Genre]>?
    
    private(set) var isLoading: Bool = false {
        didSet { onLoadingStateChange?(isLoading) }
    }
    
    func loadGenres() {
        onLoadingStateChange?(true)
        genresLoader.load { [weak self] result in
            if let genres = try? result.get() {
                self?.onGenresLoad?(genres)
            }
            self?.onLoadingStateChange?(false)
        }
    }
}

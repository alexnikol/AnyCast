// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public class LoadResourcePresenter {
    let genresView: GenresView
    let loadingView: GenresLoadingView
    
    public static var title: String {
        return NSLocalizedString(
            "GENRES_VIEW_TITLE",
             tableName: "Genres",
             bundle: .init(for: Self.self),
             comment: "Title for the genres view"
        )
    }
    
    public init(genresView: GenresView, loadingView: GenresLoadingView) {
        self.genresView = genresView
        self.loadingView = loadingView
    }
    
    public func didStartLoadingGenres() {
        loadingView.display(.init(isLoading: true))
    }
    
    public func didFinishLoading(with error: Error) {
        loadingView.display(.init(isLoading: false))
    }
    
    public func didFinishLoadingGenres(with genres: [Genre]) {
        genresView.display(.init(genres: genres))
        loadingView.display(.init(isLoading: false))
    }
}

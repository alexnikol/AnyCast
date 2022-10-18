// Copyright © 2022 Almost Engineer. All rights reserved.

import Foundation

public class LoadResourcePresenter {
    let genresView: GenresView
    let loadingView: GenresLoadingView
        
    public init(genresView: GenresView, loadingView: GenresLoadingView) {
        self.genresView = genresView
        self.loadingView = loadingView
    }
    
    public func didStartLoading() {
        loadingView.display(.init(isLoading: true))
    }
    
    public func didFinishLoading(with error: Error) {
        loadingView.display(.init(isLoading: false))
    }
    
    public func didFinishLoading(with genres: [Genre]) {
        genresView.display(.init(genres: genres))
        loadingView.display(.init(isLoading: false))
    }
}
